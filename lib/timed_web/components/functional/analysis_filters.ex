defmodule TimedWeb.Components.AnalysisFilters do
  @moduledoc """
   Component for AnalsysFilters
  """
  use Phoenix.Component

  alias Timed.Projects

  def customer_dropdown(assigns) do
    ~H"""
    <.form :let={f} for={%{"customer_id" => nil}} phx-change="change">
      <LiveSelect.live_select
        field={f[:customer_id]}
        placeholder="Select customer"
        options={@customer_options}
        update_min_len={0}
        allow_clear
        text_input_class="rounded-md w-full disabled:bg-gray-100 disabled:placeholder:text-gray-400 disabled:text-gray-400 pr-6 dark:bg-neutral-800 dark:text-white"
        dropdown_class="absolute rounded-md shadow z-50 bg-gray-100 inset-x-0 top-full mt-2 dark:bg-neutral-600 dark:text-white"
        clear_button_extra_class="dark:text-white"
      />
    </.form>
    """
  end

  def assign_customer_options(socket) do
    assign(
      socket,
      :customer_options,
      Projects.get_customers!() |> Enum.map(&%{label: &1.name, value: &1.id})
    )
  end
end
