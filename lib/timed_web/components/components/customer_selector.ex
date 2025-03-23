defmodule TimedWeb.Components.CustomerSelector do
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
        :customers,
        Projects.get_customers!()
      )
      |> assign_selected_customer()
    }
  end

  @impl true
  def handle_event("search", %{"search-customer" => ""}, socket) do
    {
      :noreply,
      assign(socket, :customers, Projects.get_customers!())
    }
  end

  def handle_event("search", %{"search-customer" => search}, socket) do
    {
      :noreply,
      assign(socket, :customers, Projects.search_customers!(search))
    }
  end

  @impl true
  def handle_event("clear-search", _, socket) do
    {
      :noreply,
      assign(socket, :customers, Projects.get_customers!())
    }
  end

  defp assign_selected_customer(socket) do
    assign(
      socket,
      :selected_customer,
      Enum.find(
        socket.assigns.customers,
        &(&1.id === socket.assigns.selected_customer_id)
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
        options={@customers}
        on_select="select-customer"
        search_input="search-customer"
        target={@myself}
        report_row_component={@target}
        field={@field}
      >
        <:placeholder>
          <%= if @selected_customer do %>
            {@selected_customer.name}
          <% else %>
            Please select a customer
          <% end %>
        </:placeholder>
        <:option :let={customer}>{customer.name}</:option>
      </TimedWeb.Components.ReportRow.searchable_dropdown>
    </div>
    """
  end
end
