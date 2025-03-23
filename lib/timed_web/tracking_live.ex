defmodule TimedWeb.TrackingLive do
  use TimedWeb, :live_view

  alias Timed.Tracking

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_reports()
    }
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  defp assign_reports(socket) do
    assign(socket, :reports, Tracking.get_reports!(load: [task: [project: :customer]]))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="reports">
      <.live_component
        :for={report <- @reports}
        module={TimedWeb.Components.ReportRow}
        id={"report-#{report.id}"}
        report={report}
      />
      <.live_component module={TimedWeb.Components.ReportRow} id="report-new" report={nil} />
    </div>
    """
  end
end
