defmodule TimedWeb.Components.ReportRow do
  @moduledoc """
  Row that reports a single report. Also contains an AshPhoenix form to create a new task or update an existing report.
  """
  alias Timed.Tracking.Report
  alias TimedWeb.Components.CustomerSelector
  alias TimedWeb.Components.ProjectSelector
  alias TimedWeb.Components.TaskSelector
  use TimedWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_selected_customer_id()
      |> assign_selected_project_id()
      |> assign(:form, AshPhoenix.Form.for_update(assigns.report, :update))
    }
  end

  defp assign_selected_customer_id(socket) do
    assign(socket, :selected_customer_id, socket.assigns.report.task.project.customer.id)
  end

  defp assign_selected_project_id(socket) do
    assign(socket, :selected_project_id, socket.assigns.report.task.project.id)
  end

  @impl true
  def handle_event("select-customer", %{"id" => customer_id}, socket) do
    {
      :noreply,
      socket
      |> assign(:selected_customer_id, customer_id)
      |> assign(:selected_project_id, nil)
      |> assign(:form, AshPhoenix.Form.validate(socket.assigns.form, %{task_id: nil}))
    }
  end

  @impl true
  def handle_event("select-project", %{"id" => project_id}, socket) do
    {
      :noreply,
      socket
      |> assign(:selected_project_id, project_id)
      |> assign(:form, AshPhoenix.Form.validate(socket.assigns.form, %{task_id: nil}))
    }
  end

  @impl true
  def handle_event("select-task", %{"id" => task_id}, socket) do
    {
      :noreply,
      assign(socket, :form, AshPhoenix.Form.validate(socket.assigns.form, %{task_id: task_id}))
    }
  end

  @impl true
  def handle_event("validate", form_params, socket) do
    {
      :noreply,
      assign(
        socket,
        :form,
        AshPhoenix.Form.validate(socket.assigns.form, form_params)
      )
    }
  end

  @impl true
  def handle_event("save", params, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, report} ->
        # todo: inform parent that we have saved succesfully
        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end

  attr :report, Report,
    default: nil,
    doc: "Report to update. If given nil a form for a new report will be created"

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        :let={f}
        for={to_form(@form)}
        as={String.to_atom("report-form-#{@report.id}")}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="report-row grid grid-cols-4 gap-2 p-1 lg:grid-cols-[repeat(3,minmax(0,0.9fr)),minmax(0,1.6fr),minmax(0,0.45fr),minmax(2rem,0.6fr),repeat(2,minmax(2rem,0.6fr))] lg:p-1.5 xl:grid-cols-[repeat(3,minmax(0,1.2fr)),minmax(0,1.8fr),minmax(0,0.4fr),minmax(2rem,0.5fr),repeat(2,minmax(2rem,0.5fr))] xl:p-2.5 max-lg:[&>*]:w-full"
      >
        <.live_component
          module={CustomerSelector}
          id={"customer-selector-#{@report.id}"}
          report={@report}
          selected_customer_id={@selected_customer_id}
          target={@myself}
        />

        <.live_component
          module={ProjectSelector}
          id={"project-selector-#{@report.id}"}
          report={@report}
          selected_customer_id={@selected_customer_id}
          selected_project_id={@selected_project_id}
          target={@myself}
        />

        <.live_component
          module={TaskSelector}
          id={"task-selector-#{@report.id}"}
          form={@form}
          selected_project_id={@selected_project_id}
          report={@report}
          target={@myself}
        />

        <div class="form-list-cell form-group max-lg:col-span-full">
          <.input
            field={f[:comment]}
            name="comment"
            class="form-control comment-field rounded"
            placeholder="Comment"
            spellcheck="true"
            type="text"
            phx-debounce="100"
          />
        </div>

        <div class="form-list-cell form-group cell-duration">
          <%!-- TODO: figure out postgres duration type --%>
          <%!-- <.input
            field={f[:duration]}
            name="duration"
            class="duration-day form-control rounded"
            placeholder="00:00"
            autocomplete="off"
            spellcheck="true"
            title="Task duration"
            pattern="^(?:[01]?\d|2[0-3])?:?(?:00|15|30|45)?$"
            maxlength="5"
            type="text"
            aria-label="duration picker"
          /> --%>
        </div>

        <div class="form-list-cell form-group cell-review-billable-icons grid grid-cols-2 content-between gap-1 self-center">
          <.toggle_button field={f[:review]} title="Needs review" icon="hero-user" />

          <.toggle_button field={f[:not_billable]} title="Not billable" icon="hero-currency-dollar" />
        </div>

        <div class="form-list-cell form-group cell-buttons grid grid-cols-2 justify-around gap-2 self-center text-sm [&>*]:px-2">
          <.button class="bg-danger hover:bg-danger"><.icon name="hero-trash" /></.button>
          <.button
            disabled={!@form.changed? || !@form.valid?}
            class={"bg-primary hover:bg-primary #{(!@form.changed? || !@form.valid?) && "cursor-not-allowed"}"}
            type="submit"
          >
            <.icon name="hero-bookmark-square" />
          </.button>
        </div>
      </.form>
    </div>
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

  attr :disabled, :boolean,
    default: false,
    doc: "If the button to open the dropdown should be disabled"

  slot :placeholder, required: true
  slot :option, required: true

  def searchable_dropdown(assigns) do
    ~H"""
    <div class="relative group" phx-click={JS.remove_class("hidden", to: {:inner, ".dropdown"})}>
      <button
        type="button"
        disabled={@disabled}
        class={[
          @disabled && "cursor-not-allowed",
          "inline-flex justify-between w-full px-4 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-blue-500"
        ]}
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

  attr :field, Phoenix.HTML.FormField, required: true, doc: "The FormField of the input field"
  attr :title, :string, required: true, doc: "The tooltip title of the button"

  defp toggle_button(assigns) do
    ~H"""
    <div
      class={[
        "form-control toggle inactive mx-0.5 grid place-self-center stroke-slate-600 p-1 text-xl",
        !@field.value && "text-primary"
      ]}
      title={@title}
      tabindex="0"
      role="link"
    >
      <div class="relative size-8">
        <label>
          <.icon name={@icon} class="absolute inset-0 size-8" />
          <.input field={@field} name={@field.field} type="checkbox" input_class="hidden" />
        </label>
      </div>
    </div>
    """
  end
end
