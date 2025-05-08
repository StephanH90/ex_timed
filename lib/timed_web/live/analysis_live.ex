defmodule TimedWeb.AnalysisLive do
  alias Timed.Tracking
  use TimedWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :reports, Tracking.get_reports!(load: [:user, task: [project: :customer]]))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>AnalysisLive</.h1>

    <.table id="reports" rows={@reports} wrapping_class="mt-8">
      <:col :let={row} label="User">{row.user.username}</:col>
      <:col :let={row} label="Date">{row.date}</:col>
      <:col :let={row} label="Duration">{row.duration}</:col>
      <:col :let={row} label="Customer">{row.task.project.customer.name}</:col>
      <:col :let={row} label="Project">{row.task.project.name}</:col>
      <:col :let={row} label="Task">{row.task.name}</:col>
      <:col :let={row} label="Comment">{row.comment}</:col>
      <:col :let={row} label="Verified by">not implemented yet</:col>
      <:col :let={row} label="Rejected 	Review 	Not billable 	Billed">not implemented yet</:col>
    </.table>
    """
  end
end
