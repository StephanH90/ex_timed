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

  defp assign_day(socket, %{"day" => day}) do
    case Date.from_iso8601(day) do
      {:ok, date} -> assign(socket, :day, date)
      {:error, _reason} -> assign(socket, :day, Date.utc_today())
    end
  end

  defp assign_day(socket, _), do: assign(socket, :day, Date.utc_today())

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
    <div class="grid--12of12 grid">
      <div class="grid md:grid-cols-[minmax(0,1fr),auto]">
        <h1 class="block max-md:mb-2">Thursday, 27.03.2025</h1>
        <%!-- <.date_navigation day={@day} /> --%>
      </div>
      <.live_component id="weekly-overview" module={TimedWeb.Components.WeeklyOverview} day={@day} />
    </div>
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

  attr :day, Date, required: true

  defp date_navigation(assigns) do
    ~H"""
    <div class="flex h-full flex-row justify-between">
      <div>
        <button
          title="Create a magic link"
          class="rounded bg-gray-200 btn btn-default h-full size-16"
          type="button"
        >
          <.icon name="hero-bolt" />
        </button>
      </div>
      <div class="btn-group mx-6 flex h-full flex-row">
        <.link
          patch={~p"/tracking?#{[day: previous_day(@day)]}"}
          class="size-16 bg-gray-200 btn btn-default flex items-center justify-center"
        >
          <span class="sr-only">previous day</span>
          <.icon name="hero-arrow-left" />
        </.link>
        <.link
          patch={~p"/tracking"}
          class="size-16 bg-gray-200 btn btn-default flex items-center justify-center"
        >
          Today
        </.link>
        <.link
          patch={~p"/tracking?#{[day: next_day(@day)]}"}
          class="size-16 bg-gray-200 btn btn-default flex items-center justify-center"
        >
          <span class="sr-only">next day</span>
          <.icon name="hero-arrow-right" />
        </.link>
      </div>

      <div
        id="ember21"
        class="ember-view ember-basic-dropdown-trigger



    "
        tabindex="0"
        role="button"
        data-ebd-id="ember20-trigger"
        aria-owns="ember-basic-dropdown-content-ember20"
        aria-controls="ember-basic-dropdown-content-ember20"
        aria-expanded="false"
        aria-disabled="false"
      >
        <button class="btn btn-default h-full" type="button">
          <svg
            class="svg-inline--fa fa-calendar"
            data-prefix="far"
            data-icon="calendar"
            aria-hidden="true"
            focusable="false"
            role="img"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 448 512"
          >
            <path
              fill="currentColor"
              d="M152 24c0-13.3-10.7-24-24-24s-24 10.7-24 24V64H64C28.7 64 0 92.7 0 128v16 48V448c0 35.3 28.7 64 64 64H384c35.3 0 64-28.7 64-64V192 144 128c0-35.3-28.7-64-64-64H344V24c0-13.3-10.7-24-24-24s-24 10.7-24 24V64H152V24zM48 192H400V448c0 8.8-7.2 16-16 16H64c-8.8 0-16-7.2-16-16V192z"
            >
            </path>
          </svg>
        </button>
      </div>

      <div
        id="ember-basic-dropdown-content-ember20"
        class="ember-basic-dropdown-content-placeholder"
        style="display: none;"
      >
      </div>
    </div>
    """
  end

  defp previous_day(day), do: Date.add(day, -1) |> Date.to_iso8601()
  defp next_day(day), do: Date.add(day, 1) |> Date.to_iso8601()
end
