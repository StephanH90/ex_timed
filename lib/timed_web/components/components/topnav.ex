defmodule TimedWeb.Components.Topnav do
  @moduledoc false
  use TimedWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed left-0 top-0 z-40 w-full">
      <nav class="bg-background dark:bg-background-muted flex w-full flex-col px-2 py-1 shadow-md transition-all md:flex-row lg:px-3.5 lg:py-0.5 xl:px-4 xl:py-0">
        <header class="flex justify-between max-md:mb-1">
          <%!-- <button
        class="w-12 md:hidden"
        type="button"
        {{on "click" (toggle "expand" this)}}
      >
        <FaIcon
          @icon={{if this.expand "chevron-up" "bars"}}
          @rotation={{if this.expand 180 0}}

          @size="2x"
        />
      </button> --%>
          <.navlink
            patch={~p"/tracking"}
            class="mr-1 grid place-items-center transition-[margin] md:grid-cols-2 lg:mr-2"
          >
            <%!-- <TimedClock class="p-1" /> --%>
            <div class="leading-4 transition-all max-md:hidden lg:ml-1 lg:text-[1.075rem]">
              Timed
              <div class="text-2xs text-foreground-muted font-mono font-normal">
                <%!-- v{{app-version versionOnly=true showExtended=true}} --%>
              </div>
            </div>
          </.navlink>
        </header>
        <section class="w-full md:flex md:max-h-full md:w-auto md:flex-grow md:flex-row max-md:block max-md:h-full max-md:max-h-96 max-md:overflow-y-auto">
          <.topnav_list>
            <.topnav_list_item class="max-md:w-full">
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-clock" />
                <span>Tracking</span>
              </.navlink>
            </.topnav_list_item>
            <%!-- {{#if (can "access page")}} --%>
            <.topnav_list_item class="max-md:hidden">
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-chart-line" /> Analysis
              </.navlink>
            </.topnav_list_item>
            <.topnav_list_item>
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-chart-bar" /> Statistics
              </.navlink>
            </.topnav_list_item>
            <.topnav_list_item>
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-briefcase" /> Projects
              </.navlink>
            </.topnav_list_item>
            <%!-- {{/if}} --%>
            <%!-- {{#if this.currentUser.user.isSuperuser}} --%>
            <.topnav_list_item>
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-users" /> Users
              </.navlink>
            </.topnav_list_item>
            <%!-- {{/if}} --%>
          </.topnav_list>
          <.topnav_list class="md:ml-auto md:border-t-0">
            <%!-- <ReportReviewWarning @class="max-md:hidden" /> --%>
            <.topnav_list_item>
              <.navlink patch={~p"/tracking"}>
                <.icon name="hero-user" />
                <%!-- {{this.currentUser.user.fullName}} --%>
              </.navlink>
            </.topnav_list_item>
            <.topnav_list_item>
              <.navlink data-test-logout>
                <.icon name="hero-power-off" /> Logout
              </.navlink>
            </.topnav_list_item>
          </.topnav_list>
        </section>
      </nav>
    </div>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  defp topnav_list_item(assigns) do
    ~H"""
    <li class="text-sm max-md:w-full lg:text-[0.9rem]" {@rest}>{render_slot(@inner_block)}</li>
    """
  end

  attr :rest, :global
  slot :inner_block, required: true

  defp topnav_list(assigns) do
    ~H"""
    <ul class="flex h-full flex-col md:flex-row" {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  slot :inner_block, required: true
  attr :patch, :string, default: nil
  attr :rest, :global

  defp navlink(assigns) do
    ~H"""
    <.link
      href="#"
      class="gap-1 grid grid-cols-[auto,minmax(0,1fr)] h-full hover:[&:not(.active)]:bg-primary-light hover:text-foreground-primary items-center lg:gap-2 md:place-items-center md:self-center [&:not(.active,:hover)]:text-tertiary py-2 px-2.5  transition-[font-size] w-full"
      patch={@patch}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
