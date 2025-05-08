defmodule TimedWeb.TrackingLive do
  use TimedWeb, :live_view
  import TimedWeb.CoreComponents, only: [icon: 1]

  alias Timed.Tracking

  # on_mount {TimedWeb.LiveUserAuth, :live_user_optional}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
    asdfasdfaas12dfsdf <.title_bar />
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
        class="ember-view ember-basic-dropdown-trigger"
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

  defp title_bar(assigns) do
    ~H"""
    <h1>test1212311123sdsdf23233</h1>
    """
  end
end
