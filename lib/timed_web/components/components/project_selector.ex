defmodule TimedWeb.Components.ProjectSelector do
  @moduledoc false
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
        Projects.get_projects_for_customer!(assigns.selected_customer_id)
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
        &(&1.id === socket.assigns.selected_project_id)
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
        disabled={is_nil(@selected_customer_id)}
      >
        <:placeholder>
          <.placeholder_text
            selected_customer_id={@selected_customer_id}
            selected_project={@selected_project}
          />
        </:placeholder>
        <:option :let={project}>{project.name}</:option>
      </TimedWeb.Components.ReportRow.searchable_dropdown>
    </div>
    """
  end

  defp placeholder_text(%{selected_customer_id: nil} = assigns),
    do: ~H"Please select a customer first"

  defp placeholder_text(%{selected_project: nil} = assigns), do: ~H"Please select a project"
  defp placeholder_text(assigns), do: ~H"{@selected_project.name}"
end
