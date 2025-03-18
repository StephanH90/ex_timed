defmodule TimedWeb.Components.CustomerSelector do
  use TimedWeb, :live_component

  alias Timed.Projects

  @impl true
  def mount(socket) do
    {
      :ok,
      assign(socket, :customers, Projects.get_customers!())
    }
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) when search !== "" do
    {
      :noreply,
      assign(socket, :customers, Projects.search_customers!(search))
    }
  end

  @impl true
  def handle_event("search", _unsigned_params, socket) do
    {
      :noreply,
      assign(socket, :customers, Projects.get_customers!())
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="" phx-click-away={JS.add_class("hidden", to: "#dropdown-menu")} phx-target={@myself}>
      <div class="relative group">
        <button
          id="dropdown-button"
          type="button"
          phx-click={JS.remove_class("hidden", to: "#dropdown-menu")}
          phx-target={@myself}
          class="inline-flex justify-between w-full px-4 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-blue-500"
        >
          <span class="mr-2">Customer</span>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-5 h-5 ml-2 -mr-1"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M6.293 9.293a1 1 0 011.414 0L10 11.586l2.293-2.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
        <div
          id="dropdown-menu"
          class="hidden absolute right-0 left-0 mt-2 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 p-1 space-y-1"
        >
          <!-- Search input -->
          <input
            id="search-input"
            class="block w-full px-4 py-2 text-gray-800 border rounded-md  border-gray-300 focus:outline-none"
            type="text"
            placeholder="Search customers"
            autocomplete="off"
            phx-change="search"
            phx-target={@myself}
            name="search"
            phx-debounce="300"
          />
          <a
            :for={customer <- @customers}
            href="#"
            class="block px-4 py-2 text-gray-700 hover:bg-gray-100 active:bg-blue-100 cursor-pointer rounded-md"
          >
            {customer.name} ({customer.email})
          </a>
        </div>
      </div>
    </div>
    """
  end
end
