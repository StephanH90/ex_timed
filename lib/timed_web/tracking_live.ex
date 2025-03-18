defmodule TimedWeb.TrackingLive do
  alias Timed.Tracking
  use TimedWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_reports()
    }
  end

  defp assign_reports(socket) do
    assign(socket, :reports, Tracking.get_reports!(load: [task: :project]))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="reports">
      <.report_row :for={report <- @reports} report={report} />
    </div>
    """
  end

  defp report_row(assigns) do
    ~H"""
    <form class="report-row grid grid-cols-4 gap-2 p-1 lg:grid-cols-[repeat(3,minmax(0,0.9fr)),minmax(0,1.6fr),minmax(0,0.45fr),minmax(2rem,0.6fr),repeat(2,minmax(2rem,0.6fr))] lg:p-1.5 xl:grid-cols-[repeat(3,minmax(0,1.2fr)),minmax(0,1.8fr),minmax(0,0.4fr),minmax(2rem,0.5fr),repeat(2,minmax(2rem,0.5fr))] xl:p-2.5 max-lg:[&>*]:w-full">
      <.live_component
        module={TimedWeb.Components.CustomerSelector}
        id={"customer-select-#{@report.id}"}
      />
      <div class="form-list-cell form-group max-lg:col-span-full">
        <label for="row-comment" hidden>Comment</label>
        <input
          type="text"
          class={[
            "form-control comment-field rounded",
            @report.task.project.customer_visible && "customer-comment"
          ]}
          placeholder="Comment"
          name="comment"
          id="row-comment"
          value={@report.comment}
          title={
            @report.task.project.customer_visible &&
              "This project's comments are visible to the customer"
          }
          spellcheck="true"
          data-test-report-comment
        />
      </div>
      <div class="form-list-cell form-group cell-duration">
        <.durationpicker_day
          data-test-report-duration
          duration={@report.duration}
          maxlength={5}
          disabled={false}
          title="Task duration"
        />
      </div>
    </form>
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
