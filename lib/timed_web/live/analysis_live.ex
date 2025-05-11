defmodule TimedWeb.AnalysisLive do
  alias Timed.Projects
  alias Timed.Tracking
  alias Timed.Tracking.Report
  alias TimedWeb.Components.AnalysisFilters
  use TimedWeb, :live_view
  import TimedWeb.CoreComponents, only: [icon: 1]

  @impl true
  def handle_params(params, _uri, socket) do
    reports =
      Tracking.get_reports!(
        load: [:user, :verified_by, task: [project: :customer]],
        page: [
          offset: 0,
          limit: 50,
          count: true
        ],
        query: [
          sort: Ash.Sort.parse_input!(Report, params["sort"]),
          filter: params["filter"] && Ash.Filter.parse_input!(Report, params["filter"])
        ]
      )

    {
      :noreply,
      assign(socket,
        reports: reports.results,
        sort: params["sort"],
        params: params
      )
    }
  end

  # @impl true
  def handle_event("update-filters", form_params, socket) do
    AnalysisFilters.handle_filters_change(socket, form_params)
  end

  @impl true
  def handle_event("sort", %{"sort" => sort}, socket) do
    params = Map.put(socket.assigns.params, "sort", sort)

    {:noreply, push_patch(socket, to: ~p"/analysis?#{params}")}
  end

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    filtered_options =
      Enum.filter(socket.assigns.customer_options, fn option ->
        String.contains?(String.downcase(option.label), String.downcase(text))
      end)

    send_update(LiveSelect.Component, id: live_select_id, options: filtered_options)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Sidebar Trigger Button --%>
    <button
      type="button"
      class="fixed left-0 top-14 2xl:hidden py-3 px-4 inline-flex items-center gap-x-2 text-sm rounded-bl-none rounded-tl-none rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none dark:focus:outline-none dark:focus:ring-1 dark:focus:ring-gray-600"
      phx-click={open_overlay("#filters-sidebar")}
    >
      <.icon name="hero-adjustments-horizontal" />
    </button>

    <div
      id="filters-sidebar"
      class="hs-overlay [--auto-close:2xl] 2xl:block 2xl:translate-x-0 2xl:end-auto 2xl:bottom-0 w-96 hs-overlay-open:translate-x-0 -translate-x-full   transition-all duration-300 transform h-full hidden fixed top-0 start-0 bottom-0 z-60 bg-white border-e border-gray-200 dark:bg-neutral-800 dark:border-neutral-700"
      role="dialog"
      tabindex="-1"
      aria-label="Sidebar"
      phx-hook="hs:sidebar"
    >
      <button
        type="button"
        class="absolute top-4 right-4 2xl:hidden  flex justify-center items-center gap-x-3 size-6 bg-white border border-gray-200 text-sm text-gray-600 hover:bg-gray-100 rounded-full disabled:opacity-50 disabled:pointer-events-none focus:outline-hidden focus:bg-gray-100 dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:focus:bg-neutral-700 dark:hover:text-neutral-200 dark:focus:text-neutral-200"
        phx-click={close_overlay("#filters-sidebar")}
      >
        <.icon name="hero-x-mark" class="size-4" />
      </button>

      <div class="mt-4 mx-4 space-y-4 h-full overflow-y-auto [&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-track]:bg-gray-100 [&::-webkit-scrollbar-thumb]:bg-gray-300 dark:[&::-webkit-scrollbar-track]:bg-neutral-700 dark:[&::-webkit-scrollbar-thumb]:bg-neutral-500 dark:text-white">
        <div class="flex items-center justify-between">
          <.h4>Filters</.h4>
          <.button size={:sm} phx-click={JS.patch(~p"/analysis")}>Reset</.button>
        </div>
        <TimedWeb.Components.AnalysisFilters.render_filters params={@params} />
      </div>
    </div>

    <%!-- Main Content --%>
    <div class="2xl:ml-96">
      <.h1>Analysis</.h1>
      <.table
        id="reports"
        rows={@reports}
        wrapping_class="mt-8"
        header_col_click={&sort_by/2}
        sort={@sort}
      >
        <:col :let={row} label="User" sort_attr="user.username">
          {row.user.username}
        </:col>
        <:col :let={row} label="Date" sort_attr="date">{row.date}</:col>
        <:col :let={row} label="Duration">{row.duration}</:col>
        <:col :let={row} label="Customer">{row.task.project.customer.name}</:col>
        <:col :let={row} label="Project">{row.task.project.name}</:col>
        <:col :let={row} label="Task">{row.task.name}</:col>
        <:col :let={row} label="Comment">{row.comment}</:col>
        <:col :let={row} label="Verified by">
          {if row.verified_by, do: row.verified_by.username, else: "-"}
        </:col>
        <:col :let={_row} label="Rejected Review Not billable Billed">not implemented yet</:col>
      </.table>
    </div>
    """
  end

  defp sort_by(js \\ %JS{}, col, current_sort) do
    new_sort = (col.sort_attr === current_sort && "-#{current_sort}") || col.sort_attr

    js
    |> JS.push("sort", value: %{sort: new_sort})
  end
end
