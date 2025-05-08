defmodule TimedWeb.Components.WeeklyOverview do
  @moduledoc """
  Shows the recorded time as bars for different days.
  """
  alias Timed.Tracking
  use TimedWeb, :live_component
  alias Timed.Statistics.Day

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> load_days()
    }
  end

  defp load_days(socket) do
    start_date = Date.utc_today() |> Date.add(-10)
    end_date = Date.utc_today() |> Date.add(10)

    reports_within_date_range = Tracking.get_reports_within_date_range!(start_date, end_date)
    first_user_id = 1

    %{records: days} =
      Enum.map(-10..10, fn i ->
        date = Date.add(socket.assigns.day, i)

        reports_on_day = Enum.filter(reports_within_date_range, &(&1.date == date))

        # hardcoded to user_id 1 for now. Would be replaced with actor(:id)
        %{
          date: date,
          user_id: first_user_id,
          reports: reports_on_day
        }
      end)
      |> Ash.bulk_create!(Day, :create,
        load: :duration,
        return_records?: true,
        return_errors?: true
      )

    assign(socket, :days, days)
  end

  attr :day, Date, default: Date.utc_today()

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div
        class="flex w-full overflow-hidden pb-12 pl-8 pt-5 sm:pl-10 md:pl-12"
        style="height: 150px;"
      >
        <div class="relative flex flex-grow items-end justify-around">
          <div class="absolute inset-0 flex items-center">
            <span
              class="absolute -left-8 right-0 w-6 translate-y-1/2 text-center text-xs
        text-foreground-muted"
              style="bottom: calc(100%);"
            >
              20h
            </span>
            <hr
              class="absolute left-0 right-0 m-0 w-full border-none p-0
      bg-primary/30 h-px"
              style="bottom: calc(100%);"
            />
          </div>
          <div :for={percentage <- 90..10//-10} class="absolute inset-0 flex items-center">
            <hr
              class="absolute left-0 right-0 m-0 w-full border-none p-0 bg-primary/30 h-px"
              style={"bottom: calc(#{percentage}%);"}
            />
          </div>
          <div class="absolute inset-0 flex items-center">
            <span
              class="absolute -left-8 right-0 w-6 translate-y-1/2 text-center text-xs
        text-foreground-muted"
              style="bottom: calc(0%);"
            >
              0h
            </span>
            <hr
              class="absolute left-0 right-0 m-0 w-full border-none p-0
      bg-primary/30 h-px"
              style="bottom: calc(0%);"
            />
          </div>

          <div class="absolute inset-0 flex items-center">
            <span
              class="absolute -left-8 right-0 w-6 translate-y-1/2 text-center text-xs
        "
              style="bottom: calc(40%);"
            >
              8h
            </span>
            <hr
              class="absolute left-0 right-0 m-0 w-full border-none p-0
      bg-tertiary/60 h-[1.5px]"
              style="bottom: calc(40%);"
            />
          </div>

          <.weekly_overview_day :for={day <- @days} day={day} />
        </div>
      </div>
    </div>
    """
  end

  attr :day, Timed.Statistics.Day, required: true

  defp weekly_overview_day(assigns) do
    ~H"""
    <.link
      patch={~p"/tracking?#{[day: Date.to_iso8601(@day.date)]}"}
      title="7h 45m"
      class="weekly-overview-day relative z-10 h-full min-h-full w-4 cursor-pointer [&amp;>*]:transition-colors text-overview-workday hover:text-overview-workday-hf focus:text-overview-workday-hf [&amp;.active]:text-overview-workday-active"
      type="button"
    >
      <div
        class="bar bottom-0 absolute h-full w-full bg-current"
        style={"height: #{calculate_height(@day.duration)}%"}
      >
      </div>
      <div class="day absolute -bottom-[2.5em] left-1/2 -translate-x-1/2 text-center text-sm font-medium leading-4">
        {@day.date}
      </div>
    </.link>
    """
  end

  defp calculate_height(duration) do
    min(100, duration / (20 * 60) * 100)
  end
end
