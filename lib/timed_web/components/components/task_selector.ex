defmodule TimedWeb.Components.TaskSelector do
  use TimedWeb, :live_component
  alias Timed.Projects

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:tasks, Projects.get_tasks_for_project!(assigns.report.task.project.id))
      |> assign_selected_task()
    }
  end

  defp assign_selected_task(socket) do
    assign(
      socket,
      :selected_task,
      Enum.find(
        socket.assigns.tasks,
        &(&1.id === AshPhoenix.Form.value(socket.assigns.form, :task_id))
      )
    )
  end

  attr :target, :any,
    required: true,
    doc: "The target (@myself, or any valid DOM selector) that will handle phx-events"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <TimedWeb.Components.ReportRow.searchable_dropdown
        options={@tasks}
        on_select="select-task"
        target={@target}
      >
        <:placeholder>
          <%= if @selected_task do %>
            {@selected_task.name}
          <% else %>
            Please select a task
          <% end %>
        </:placeholder>
        <:option :let={task}>{task.name}</:option>
      </TimedWeb.Components.ReportRow.searchable_dropdown>
    </div>
    """
  end
end
