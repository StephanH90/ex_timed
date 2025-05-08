defmodule TimedWeb.Components.Layout do
  use TimedWeb, :html

  def header(assigns) do
    ~H"""
    <header class="sticky top-0 inset-x-0 flex flex-wrap md:justify-start md:flex-nowrap z-48 w-full bg-white border-b border-gray-200 text-sm py-2.5 lg:ps-65 dark:bg-neutral-800 dark:border-neutral-700">
      <nav class="px-4 sm:px-6 flex basis-full items-center w-full mx-auto">
        <div class="me-5 lg:me-0 lg:hidden">
          INSERT LOGO HERE
        </div>

        <div class="w-full flex items-center justify-end ms-auto md:justify-between gap-x-1 md:gap-x-3">
          <div class="hidden md:block">
            <div class="relative">
              <div class="absolute inset-y-0 start-0 flex items-center justify-center pointer-events-none z-20 ps-3.5">
                <.icon name="hero-magnifying-glass" class="absolute size-6 left-2 text-neutral-600" />
              </div>
              <input
                type="text"
                class="py-2 ps-10 pe-16 block w-full bg-white border-gray-200 border rounded-lg text-sm focus:outline-hidden focus:border-blue-500 focus:ring-blue-500 checked:border-blue-500 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-neutral-400 dark:placeholder:text-neutral-400 dark:focus:ring-neutral-600"
                placeholder="Search"
              />
            </div>
          </div>
        </div>
      </nav>
    </header>
    """
  end
end
