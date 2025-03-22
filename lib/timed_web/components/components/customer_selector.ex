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
        target={@target}
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
