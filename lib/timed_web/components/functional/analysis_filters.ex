defmodule TimedWeb.Components.AnalysisFilters do
  @moduledoc """
   Component for AnalsysFilters
  """
  use Phoenix.Component
  use TimedWeb, :verified_routes
  import Phoenix.LiveView, only: [push_patch: 2, send_update: 2]
  import TimedWeb.CoreComponents, only: [input: 1]

  alias Timed.Projects

  def render_filters(assigns) do
    assigns =
      assigns
      |> assign(:customer_options, Projects.get_customers!() |> to_options())
      |> assign_attribute(:customer_id, ~w(filter task project customer id))
      |> assign_attribute(:project_id, ~w(filter task project id))
      |> assign_attribute(:comment, ~w(filter comment contains))
      |> assign_filters()
      |> assign_project_options()
      |> assign_task_options()

    # This is required because of the way the live-select component works on the inside
    send_update(LiveSelect.Component, id: "project-select", options: assigns.project_options)
    send_update(LiveSelect.Component, id: "task-select", options: assigns.task_options)

    ~H"""
    <.form :let={f} id="filters" for={to_form(@filters)} phx-change="update-filters" class="space-y-4">
      <.customer_dropdown customer_options={@customer_options} form={f} phx-blur="update-filters" />

      <.project_dropdown project_options={@project_options} form={f} />

      <.task_dropdown task_options={@task_options} form={f} />

      <.input field={f["comment"]} name="comment" phx-debounce="blur" label="Comment" />
    </.form>
    """
  end

  def handle_filters_change(socket, form_params) do
    customer_id = form_params["customer_id"] |> nil_if_blank()
    project_id = form_params["project_id"] |> nil_if_blank()
    task_id = form_params["task_id"] |> nil_if_blank()
    comment = form_params["comment"] |> nil_if_blank()

    query_params =
      socket.assigns.params
      |> set_filter(~w(filter task project customer), customer_id, %{"id" => customer_id})
      |> set_filter(~w(filter task project), project_id, %{"id" => project_id})
      |> set_filter(~w(filter task), task_id, %{"id" => task_id})
      |> set_filter(~w(filter), comment, %{"comment" => [contains: comment]})

    {:noreply, push_patch(socket, to: ~p"/analysis?#{Map.to_list(query_params)}")}
  end

  defp nil_if_blank(val) when val in [nil, ""], do: nil
  defp nil_if_blank(val), do: val

  defp assign_attribute(assigns, attribute, path) do
    assign(assigns, attribute, get_in(assigns.params, path))
  end

  defp assign_filters(assigns) do
    filters =
      %{
        "customer_id" =>
          assigns[:customer_id] !== "" &&
            Enum.find(assigns.customer_options, fn %{value: v} -> v == assigns[:customer_id] end),
        "project_id" => assigns[:project_id],
        "comment" => assigns[:comment]
      }

    assign(assigns, :filters, filters)
  end

  defp set_filter(query_params, _path, nil, _value), do: query_params

  defp set_filter(query_params, path, _value, value_as_map) do
    nested =
      path
      |> Enum.reverse()
      |> Enum.reduce(value_as_map, fn key, acc ->
        %{key => acc}
      end)

    deep_merge(query_params, nested)
  end

  defp assign_project_options(assigns = %{customer_id: customer_id})
       when customer_id !== nil and customer_id !== "" do
    project_options =
      Projects.get_projects_for_customer!(assigns[:customer_id]) |> to_options()

    assign(assigns, :project_options, project_options)
  end

  defp assign_project_options(assigns), do: assign(assigns, :project_options, [])

  defp assign_task_options(assigns = %{project_id: nil}), do: assign(assigns, :task_options, [])
  defp assign_task_options(assigns = %{project_id: ""}), do: assign(assigns, :task_options, [])

  defp assign_task_options(assigns) do
    task_options =
      Projects.get_tasks_for_project!(assigns[:project_id]) |> to_options()

    assign(assigns, :task_options, task_options)
  end

  defp to_options(list) do
    Enum.map(list, fn %{id: id, name: name} -> %{label: name, value: Integer.to_string(id)} end)
  end

  defp deep_merge(map1, map2) when is_map(map1) and is_map(map2) do
    Map.merge(map1, map2, fn _key, val1, val2 ->
      case {val1, val2} do
        {%{} = m1, %{} = m2} -> deep_merge(m1, m2)
        _ -> val2
      end
    end)
  end

  defp customer_dropdown(assigns) do
    ~H"""
    <label for="customer_id_text_input">Customer</label>
    <LiveSelect.live_select
      id="customer-select"
      field={@form["customer_id"]}
      placeholder="Select customer"
      options={@customer_options}
      update_min_len={0}
      allow_clear
      text_input_class="rounded-md w-full disabled:bg-gray-100 disabled:placeholder:text-gray-400 disabled:text-gray-400 pr-6 dark:bg-neutral-800 dark:text-white"
      dropdown_class="absolute rounded-md shadow z-50 bg-gray-100 inset-x-0 top-full mt-2 dark:bg-neutral-600 dark:text-white"
      clear_button_extra_class="dark:text-white"
    />
    """
  end

  defp project_dropdown(assigns) do
    ~H"""
    <label for="project_id_text_input">Project</label>
    <LiveSelect.live_select
      id="project-select"
      field={@form["project_id"]}
      placeholder="Select project"
      options={@project_options}
      update_min_len={0}
      allow_clear
      text_input_class="rounded-md w-full disabled:bg-gray-100 disabled:placeholder:text-gray-400 disabled:text-gray-400 pr-6 dark:bg-neutral-800 dark:text-white"
      dropdown_class="absolute rounded-md shadow z-50 bg-gray-100 inset-x-0 top-full mt-2 dark:bg-neutral-600 dark:text-white"
      clear_button_extra_class="dark:text-white"
    />
    """
  end

  defp task_dropdown(assigns) do
    ~H"""
    <label for="task_id_text_input">Task</label>
    <LiveSelect.live_select
      id="task-select"
      field={@form["task_id"]}
      placeholder="Select task"
      options={@task_options}
      update_min_len={0}
      allow_clear
      text_input_class="rounded-md w-full disabled:bg-gray-100 disabled:placeholder:text-gray-400 disabled:text-gray-400 pr-6 dark:bg-neutral-800 dark:text-white"
      dropdown_class="absolute rounded-md shadow z-50 bg-gray-100 inset-x-0 top-full mt-2 dark:bg-neutral-600 dark:text-white"
      clear_button_extra_class="dark:text-white"
    />
    """
  end
end
