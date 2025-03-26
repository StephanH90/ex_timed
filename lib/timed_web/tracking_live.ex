defmodule TimedWeb.TrackingLive do
  use TimedWeb, :live_view

  alias Timed.Tracking

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
    }
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {
      :noreply,
      socket
      |> assign_day(params)
      |> assign_reports()
    }
  end

  defp assign_day(socket, %{"day" => day}), do: assign(socket, :day, Date.from_iso8601!(day))

  defp assign_day(socket, _), do: assign(socket, :day, Date.utc_today())

  defp assign_reports(%{assigns: %{day: nil}} = socket) do
    assign(socket, :reports, Tracking.get_reports!(load: [task: [project: :customer]]))
  end

  defp assign_reports(socket) do
    # this is called "day" instead of "date" because old timed used the queryparams "day"
    assign(
      socket,
      :reports,
      Tracking.get_reports_for_date!(socket.assigns.day, load: [task: [project: :customer]])
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component id="weekly-overview" module={TimedWeb.Components.WeeklyOverview} day={@day} />
    <div class="grid-cell visible-sm grid-rows-1">
      <ul class="nav-tabs -mt-px sm:border-b grid grid-rows-1 max-sm:my-2 sm:grid-cols-[repeat(3,minmax(0,auto)),50fr]">
        <li class="grid max-sm:border max-sm:first:rounded-t-sm max-sm:last:rounded-b-sm lg:text-[1.01rem]">
          <a
            id="ember22"
            class="ember-view group max-sm:flex max-sm:justify-center sm:flex sm:items-center transition-[font-size] gap-x-1 sm:gap-x-2 py-1.5 px-2.5 lg:px-3 sm:border-background sm:border sm:bg-background sm:-mb-px sm:border-b-border hover:text-foreground-accent/80 group [&amp;.active]:sm:border-border [&amp;.active]:sm:text-foreground-accent [&amp;.active]:sm:border-b-background [&amp;.active]:max-sm:bg-background-muted [&amp;.active]:sm:rounded-t"
            href="/"
          >
            Activity
            <span class="group-[.active]:bg-primary-dark group-hover:bg-secondary/90 bg-secondary text-foreground-primary grid place-self-center whitespace-nowrap rounded-xl px-1 py-0.5 text-xs font-normal transition-[background-color] md:px-1.5 lg:px-2 lg:text-[0.8rem]">
              0h 0m 0s
            </span>
          </a>
        </li>
        <li class="grid max-sm:border max-sm:first:rounded-t-sm max-sm:last:rounded-b-sm lg:text-[1.01rem]">
          <a
            id="ember23"
            class="ember-view group max-sm:flex max-sm:justify-center sm:flex sm:items-center transition-[font-size] gap-x-1 sm:gap-x-2 py-1.5 px-2.5 lg:px-3 sm:border-background sm:border sm:bg-background sm:-mb-px sm:border-b-border hover:text-foreground-accent/80 group [&amp;.active]:sm:border-border [&amp;.active]:sm:text-foreground-accent [&amp;.active]:sm:border-b-background [&amp;.active]:max-sm:bg-background-muted [&amp;.active]:sm:rounded-t"
            href="/attendances"
          >
            Attendance
            <span class="group-[.active]:bg-primary-dark group-hover:bg-secondary/90 bg-secondary text-foreground-primary grid place-self-center whitespace-nowrap rounded-xl px-1 py-0.5 text-xs font-normal transition-[background-color] md:px-1.5 lg:px-2 lg:text-[0.8rem]">
              0h 0m
            </span>
          </a>
        </li>
        <li class="grid max-sm:border max-sm:first:rounded-t-sm max-sm:last:rounded-b-sm lg:text-[1.01rem]">
          <a
            id="ember24"
            class="ember-view active group max-sm:flex max-sm:justify-center sm:flex sm:items-center transition-[font-size] gap-x-1 sm:gap-x-2 py-1.5 px-2.5 lg:px-3 sm:border-background sm:border sm:bg-background sm:-mb-px sm:border-b-border hover:text-foreground-accent/80 group [&amp;.active]:sm:border-border [&amp;.active]:sm:text-foreground-accent [&amp;.active]:sm:border-b-background [&amp;.active]:max-sm:bg-background-muted [&amp;.active]:sm:rounded-t"
            href="/reports"
          >
            Timesheet
            <span class="group-[.active]:bg-primary-dark group-hover:bg-secondary/90 bg-secondary text-foreground-primary grid place-self-center whitespace-nowrap rounded-xl px-1 py-0.5 text-xs font-normal transition-[background-color] md:px-1.5 lg:px-2 lg:text-[0.8rem]">
              0h 0m
            </span>
          </a>
        </li>
        <!---->
        <li class="grid rounded-b-sm border first:rounded-t-sm sm:hidden">
          <button class="btn sm:btn-default rounded-none border-none" type="button">
            Add absence
          </button>
        </li>
        <li class="mt-px flex w-full gap-x-1 max-sm:hidden sm:justify-end sm:pt-px md:gap-x-2">
          <!---->
          <button
            class="mb-0.5 flex h-full items-center gap-x-2 rounded-t border !border-b-0 px-5 py-1.5 hover:text-primary hover:border-primary whitespace-nowrap"
            type="button"
          >
            Add absence
          </button>
        </li>
      </ul>
    </div>
    <div class="reports">
      <.live_component
        :for={report <- @reports}
        module={TimedWeb.Components.ReportRow}
        id={"report-#{report.id}"}
        report={report}
        day={@day}
      />
      <.live_component module={TimedWeb.Components.ReportRow} id="report-new" report={nil} day={@day} />
    </div>
    """
  end
end
