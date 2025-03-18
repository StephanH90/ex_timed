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
    </div>
    """
  end

  attr :disabled, :boolean, default: false
  attr :duration, :integer, required: false
  attr :maxlength, :integer, default: 5
  attr :title, :string
  attr :rest, :global

  defp durationpicker_day(assigns) do
    ~H"""
    <input
      aria-label="day picker"
      name="duration-day"
      pattern="^(?:[01]?\\d|2[0-3])?:?(?:00|15|30|45)?$"
      type="text"
      class="duration-day form-control rounded"
      disabled={@disabled}
      value={@duration}
      maxlength={@maxlength}
      placeholder="00:00"
      autocomplete="off"
      title={@title}
      {@rest}
    />
    """
  end
end
