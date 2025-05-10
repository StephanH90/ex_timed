defmodule TimedWeb.Components.AnalysisFilters do
  @moduledoc """
   Component for AnalsysFilters
  """
  use Phoenix.Component
  use TimedWeb, :verified_routes
  import Phoenix.LiveView, only: [push_patch: 2, send_update: 2]

  alias Timed.Projects

  def render_filters(assigns) do
    assigns =
      assigns
      |> assign(:customer_options, Projects.get_customers!() |> to_options())
      |> assign_customer_id()
      |> assign_project_id()
      |> assign_filters()
      |> assign_project_options()

    # This is required because of the way the live-select component works on the inside
    send_update(LiveSelect.Component, id: "project-select", options: assigns.project_options)

    ~H"""
    <.form :let={f} id="filters" for={to_form(@filters)} phx-change="update-filters" class="space-y-4">
      <.customer_dropdown customer_options={@customer_options} form={f} />

      <.project_dropdown project_options={@project_options} form={f} />
    </.form>
    """
  end

  def handle_filters_change(socket, form_params) do
    customer_id =
      (Map.get(form_params, "customer_id") !== "" && Map.get(form_params, "customer_id")) || nil

    project_id =
      (Map.get(form_params, "project_id") !== "" && Map.get(form_params, "project_id")) || nil

    query_params =
      socket.assigns.params
      |> set_customer_filter(customer_id)
      |> set_project_filter(project_id)

    {:noreply, push_patch(socket, to: ~p"/analysis?#{Map.to_list(query_params)}")}
  end

  defp assign_customer_id(assigns),
    do: assign(assigns, :customer_id, get_in(assigns.params, ~w(filter task project customer id)))

  defp assign_project_id(assigns),
    do: assign(assigns, :project_id, get_in(assigns.params, ~w(filter task project id)))

  defp assign_filters(assigns) do
    filters =
      %{
        "customer_id" =>
          assigns[:customer_id] !== "" &&
            Enum.find(assigns.customer_options, fn %{value: v} -> v == assigns[:customer_id] end),
        "project_id" => assigns[:project_id]
      }

    assign(assigns, :filters, filters)
  end

  defp set_customer_filter(query_params, nil), do: query_params

  defp set_customer_filter(query_params, customer_id) do
    Map.merge(query_params, %{
      "filter" => %{"task" => %{"project" => %{"customer" => %{"id" => customer_id}}}}
    })
  end

  defp set_project_filter(query_params, nil), do: query_params

  defp set_project_filter(query_params, project_id) do
    put_in(
      query_params,
      ["filter", "task", "project"],
      Map.merge(query_params["filter"]["task"]["project"], %{"id" => project_id})
    )
  end

  defp assign_project_options(assigns = %{customer_id: customer_id})
       when customer_id !== nil and customer_id !== "" do
    project_options =
      Projects.get_projects_for_customer!(assigns[:customer_id]) |> to_options()

    assign(assigns, :project_options, project_options)
  end

  defp assign_project_options(assigns), do: assign(assigns, :project_options, [])

  defp to_options(list) do
    Enum.map(list, fn %{id: id, name: name} -> %{label: name, value: Integer.to_string(id)} end)
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
end
