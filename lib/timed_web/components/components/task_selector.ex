defmodule TimedWeb.Components.TaskSelector do
  @moduledoc false
  use TimedWeb, :live_component
  alias Timed.Projects

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_tasks()
      |> assign_selected_task()
    }
  end

  defp assign_tasks(%{assigns: %{selected_project_id: nil}} = socket) do
    assign(socket, :tasks, [])
  end

  defp assign_tasks(socket) do
    assign(socket, :tasks, Projects.get_tasks_for_project!(socket.assigns.selected_project_id))
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
        disabled={is_nil(@selected_project_id)}
      >
        <:placeholder>
          <.placeholder_text
            selected_project_id={@selected_project_id}
            selected_task={@selected_task}
          />
        </:placeholder>
        <:option :let={task}>{task.name}</:option>
      </TimedWeb.Components.ReportRow.searchable_dropdown>
    </div>
    """
  end

  defp placeholder_text(%{selected_project_id: nil} = assigns),
    do: ~H"Please select project first"

  defp placeholder_text(%{selected_task: nil} = assigns), do: ~H"Please select a task"
  defp placeholder_text(assigns), do: ~H"{@selected_task.name}"
end
