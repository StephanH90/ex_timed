defmodule TimedWeb.Components.ReportRow do
  alias TimedWeb.Components.ProjectSelector
  alias TimedWeb.Components.TaskSelector
  alias Timed.Projects
  use TimedWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:form, AshPhoenix.Form.for_update(assigns.report, :update))
      |> assign(:tasks, Projects.get_tasks_for_project!(assigns.report.task.project.id))
    }
  end

  @impl true
  def handle_event("select-task", %{"id" => task_id}, socket) do
    {:noreply,
     assign(socket, :form, AshPhoenix.Form.validate(socket.assigns.form, %{task_id: task_id}))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form class="report-row grid grid-cols-4 gap-2 p-1 lg:grid-cols-[repeat(3,minmax(0,0.9fr)),minmax(0,1.6fr),minmax(0,0.45fr),minmax(2rem,0.6fr),repeat(2,minmax(2rem,0.6fr))] lg:p-1.5 xl:grid-cols-[repeat(3,minmax(0,1.2fr)),minmax(0,1.8fr),minmax(0,0.4fr),minmax(2rem,0.5fr),repeat(2,minmax(2rem,0.5fr))] xl:p-2.5 max-lg:[&>*]:w-full">
      <.live_component
        module={ProjectSelector}
        id={"project-selector-#{@report.id}"}
        report={@report}
        form={@form}
        target={@myself}
      />

      <.live_component
        module={TaskSelector}
        id={"task-selector-#{@report.id}"}
        report={@report}
        form={@form}
        target={@myself}
      />

      <%!-- <.live_component
        module={TimedWeb.Components.CustomerSelector}
        id={"customer-select-#{@report.id}"}
        task_id={Map.get(@report_form.params, :customer_id)}
      />
      <.live_component
        module={TimedWeb.Components.ProjectSelector}
        id={"customer-select-#{@report.id}"}
        customer_id={Map.get(@report_form.params, :customer_id)}
      /> --%>
      <%!-- <div class="form-list-cell form-group max-lg:col-span-full">
        <label for="row-comment" hidden>Comment</label>
        <input
          type="text"
          class={[
            "form-control comment-field rounded",
            @report.task.project.customer_visible && "customer-comment"
          ]}
          placeholder="Comment"
          name="comment"
          id="row-comment"
          value={@report.comment}
          title={
            @report.task.project.customer_visible &&
              "This project's comments are visible to the customer"
          }
          spellcheck="true"
          data-test-report-comment
        />
      </div>
      <div class="form-list-cell form-group cell-duration">
        <.durationpicker_day
          data-test-report-duration
          duration={@report.duration}
          maxlength={5}
          disabled={false}
          title="Task duration"
        />
      </div> --%>
    </form>
    """
  end

  attr :on_select, :string,
    required: true,
    doc: "The name of the event that will fire when an option is selected"

  attr :target, :any,
    required: true,
    doc: "The target (@myself, or any valid DOM selector) that will handle phx-events"

  attr :selected_option, :any, default: nil
  attr :options, :list, required: true
  slot :placeholder, required: true
  slot :option, required: true

  def searchable_dropdown(assigns) do
    ~H"""
    <div class="relative group" phx-click={JS.remove_class("hidden", to: {:inner, ".dropdown"})}>
      <button
        type="button"
        class="inline-flex justify-between w-full px-4 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-blue-500"
      >
        {render_slot(@placeholder, @selected_option)}
        <.icon class="w-5 h-5 ml-2 -mr-1" name="hero-chevron-down" />
      </button>
      <div
        phx-click-away={JS.add_class("hidden")}
        class="dropdown hidden absolute right-0 left-0 mt-2 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 p-1 space-y-1 z-10"
      >
        <!-- Search input -->
        <input
          class="block w-full px-4 py-2 text-gray-800 border rounded-md  border-gray-300 focus:outline-none"
          type="text"
          placeholder="Search customers"
          autocomplete="off"
          name="search"
          phx-debounce="300"
        />
        <a
          :for={option <- @options}
          phx-target={@target}
          phx-click={
            JS.push(@on_select, value: %{id: option.id})
            |> JS.add_class("hidden", to: {:closest, ".dropdown"})
          }
          href="#"
          class="block px-4 py-2 text-gray-700 hover:bg-gray-100 active:bg-blue-100 cursor-pointer rounded-md"
        >
          {render_slot(@option, option)}
        </a>
      </div>
    </div>
    """
  end
end
