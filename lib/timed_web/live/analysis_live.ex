defmodule TimedWeb.AnalysisLive do
  alias Timed.Tracking
  use TimedWeb, :live_view

  # @impl true
  # def mount(_params, _session, socket) do
  #   {:ok, assign(socket, :reports, reports.results)}
  # end

  @impl true
  def handle_params(%{"sort" => sort}, _uri, socket) do
    reports =
      Tracking.get_reports!(
        load: [:user, :verified_by, task: [project: :customer]],
        page: %{
          offset: 0,
          limit: 50,
          count: true
        },
        query: Ash.Query.sort_input(Tracking.Report, sort)
      )

    {:noreply, assign(socket, reports: reports.results, sort: sort)}
  end

  @impl true
  def handle_params(_, _uri, socket) do
    reports =
      Tracking.get_reports!(
        load: [:user, :verified_by, task: [project: :customer]],
        page: %{
          offset: 0,
          limit: 50,
          count: true
        }
      )

    {:noreply, assign(socket, reports: reports.results, sort: "date")}
  end

  @impl true
  def render(assigns) do
    ~H"""
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
    """
  end

  defp sort_by(js \\ %JS{}, col, current_sort) do
    new_sort = (col.sort_attr === current_sort && "-#{current_sort}") || col.sort_attr

    js
    |> JS.navigate(~p"/analysis/?#{[sort: new_sort]}")
  end
end
