defmodule TimedWeb.Components.Layout do
  use TimedWeb, :html

  attr :current_uri, :string, required: true, doc: "current route taken from the socket"

  def header(assigns) do
    ~H"""
    <header class="flex flex-wrap sm:justify-start sm:flex-nowrap z-50 w-full bg-white border-b border-gray-200 text-sm py-3 sm:py-0 dark:bg-neutral-800 dark:border-neutral-700">
      <nav
        class="relative max-w-[85rem] w-full mx-auto px-4 sm:flex sm:items-center sm:justify-between sm:px-6 lg:px-8"
        aria-label="Global"
      >
        <div class="flex items-center justify-between">
          <a class="flex-none text-xl font-semibold dark:text-white" href="#" aria-label="Brand">
            ExTimed
          </a>
          <div class="sm:hidden">
            <button
              type="button"
              class="hs-collapse-toggle size-9 flex justify-center items-center text-sm font-semibold rounded-lg border border-gray-200 text-gray-800 hover:bg-gray-100 disabled:opacity-50 disabled:pointer-events-none dark:text-white dark:border-neutral-700 dark:hover:bg-neutral-700"
              data-hs-collapse="#navbar-collapse-with-animation"
              aria-controls="navbar-collapse-with-animation"
              aria-label="Toggle navigation"
            >
              <svg
                class="hs-collapse-open:hidden size-4"
                width="16"
                height="16"
                fill="currentColor"
                viewBox="0 0 16 16"
              >
                <path
                  fill-rule="evenodd"
                  d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"
                />
              </svg>
              <svg
                class="hs-collapse-open:block hidden size-4"
                width="16"
                height="16"
                fill="currentColor"
                viewBox="0 0 16 16"
              >
                <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z" />
              </svg>
            </button>
          </div>
        </div>
        <div
          id="navbar-collapse-with-animation"
          class="hs-collapse hidden overflow-hidden transition-all duration-300 basis-full grow sm:block"
        >
          <div class="flex flex-col gap-y-4 gap-x-0 mt-5 sm:flex-row sm:items-center sm:justify-end sm:gap-y-0 sm:gap-x-7 sm:mt-0 sm:ps-7">
            <.navbar_link to={~p"/analysis"} current_uri={@current_uri} label="Analysis" />
            <.navbar_link to={~p"/tracking"} current_uri={@current_uri} label="Tracking" />

            <div class="sm:flex sm:items-center">
              <div class="relative hs-dropdown [--placement:bottom-right] [--trigger:static] sm:[--trigger:hover]">
                <div class="relative">
                  <div class="absolute inset-y-0 start-0 flex items-center pointer-events-none ps-3">
                    <svg
                      class="size-4 text-gray-500 dark:text-neutral-500"
                      xmlns="http://www.w3.org/2000/svg"
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    >
                      <circle cx="11" cy="11" r="8"></circle>
                      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                  </div>
                  <input
                    type="text"
                    id="icon"
                    name="icon"
                    class="py-2 px-3 ps-9 block w-full border-gray-200 rounded-lg text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder-neutral-500 dark:focus:ring-neutral-600"
                    placeholder="Search"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </nav>
    </header>
    """
  end

  @doc """
  Renders a navigation link for the navbar.

  It applies specific styling for active links based on the current path.

  ## Examples

      <.navbar_link to={~p"/users"} current_uri={@current_uri} label="Users" />
      <.navbar_link to={~p"/about"} current_uri={@current_uri} label="About" />

  """
  attr :to, :string, required: true
  attr :label, :string, required: true
  attr :current_uri, :string, required: true
  attr :opts, :list, default: []

  def navbar_link(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "py-0.5 md:py-3 px-4 md:px-1 border-s-2 md:border-s-0 border-gray-800 font-medium focus:outline-hidden dark:border-neutral-200 text-gray-500",
        (@to == @current_uri && "md:border-b-2 dark:text-neutral-200 text-gray-500") ||
          "hover:text-gray-400  dark:hover:text-neutral-500"
      ]}
      aria-current={@to === @current_uri && "page"}
      {@opts}
    >
      {@label}
    </.link>
    """
  end
end
