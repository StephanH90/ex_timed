defmodule TimedWeb.Components.ProjectSelector do
  use TimedWeb, :live_component
  alias Timed.Projects

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(
        :projects,
        Projects.get_projects_for_customer!(assigns.report.task.project.customer.id)
      )
      |> assign_selected_project()
    }
  end

  defp assign_selected_project(socket) do
    assign(
      socket,
      :selected_project,
      Enum.find(
        socket.assigns.projects,
        &(&1.id === AshPhoenix.Form.value(socket.assigns.form, :project_id))
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
        options={@projects}
        on_select="select-project"
        target={@target}
      >
        <:placeholder>
          <%= if @selected_project do %>
            {@selected_project.name}
          <% else %>
            Please select a project
          <% end %>
        </:placeholder>
        <:option :let={project}>{project.name}</:option>
      </TimedWeb.Components.ReportRow.searchable_dropdown>
    </div>
    """
  end
end
