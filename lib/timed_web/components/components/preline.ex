defmodule TimedWeb.Components.Preline do
  @moduledoc """
  Preline components
  """
  use Phoenix.Component
  use Gettext, backend: TimedWeb.Gettext
  import TimedWeb.CoreComponents, only: [icon: 1]
  alias Phoenix.LiveView.JS

  def open_overlay(js \\ %JS{}, overlay_id) do
    hs_event(js, detail: %{class: "HSOverlay", fun: "open", args: [overlay_id]})
  end

  def close_overlay(js \\ %JS{}, overlay_id) do
    hs_event(js, detail: %{class: "HSOverlay", fun: "close", args: [overlay_id]})
  end

  defp hs_event(js, rest) do
    JS.dispatch(js, "hs:exec", rest)
  end

  # HEADERS
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class={["text-4xl dark:text-white", @class]}>{render_slot(@inner_block)}</h1>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h2 class={["text-3xl dark:text-white", @class]}>{render_slot(@inner_block)}</h2>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block, required: true

  def h3(assigns) do
    ~H"""
    <h3 class={["text-2xl dark:text-white", @class]}>{render_slot(@inner_block)}</h3>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block, required: true

  def h4(assigns) do
    ~H"""
    <h4 class={["text-xl dark:text-white", @class]}>{render_slot(@inner_block)}</h4>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block, required: true

  def h5(assigns) do
    ~H"""
    <h5 class={["text-lg dark:text-white", @class]}>{render_slot(@inner_block)}</h5>
    """
  end

  attr :class, :string, default: ""

  slot :inner_block, required: true

  def h6(assigns) do
    ~H"""
    <h6 class={["text-base dark:text-white", @class]}>{render_slot(@inner_block)}</h6>
    """
  end

  @doc ~S"""
  Renders a preline table with generic styling.

  ## Examples

      <.table id="users" rows={@users} wrapping_class="some-class">
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  attr :wrapping_class, :string, default: "", doc: "class applied to the wrapping div"

  attr :header_col_click, :any,
    default: nil,
    doc: "the function for handling phx-click on a header column"

  attr :sort, :string, default: nil, doc: "the current sort attribute"

  slot :col, required: true do
    attr :label, :string

    attr :sort_attr, :string, doc: "if clicked sort by this attribute"
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class={["flex flex-col", @wrapping_class]}>
      <div class="-m-1.5 overflow-x-auto">
        <div class="p-1.5 min-w-full inline-block align-middle">
          <div class="overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200 dark:divide-neutral-700">
              <thead>
                <tr>
                  <th
                    :for={col <- @col}
                    class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase dark:text-neutral-500"
                    phx-click={col[:sort_attr] && @header_col_click && @header_col_click.(col, @sort)}
                  >
                    {col[:label]}
                    <.icon :if={col[:sort_attr] && @sort === col[:sort_attr]} name="hero-arrow-up" />
                    <.icon :if={col[:sort_attr] && @sort !== col[:sort_attr]} name="hero-arrow-down" />
                  </th>
                  <th
                    :if={@action != []}
                    class="px-6 py-3 text-end text-xs font-medium text-gray-500 uppercase dark:text-neutral-500"
                  >
                    <span class="sr-only">{gettext("Actions")}</span>
                  </th>
                </tr>
              </thead>
              <tbody
                id={@id}
                class="divide-y divide-gray-200 dark:divide-neutral-700"
                phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
              >
                <tr :for={row <- @rows} id={@row_id && @row_id.(row)}>
                  <td
                    :for={{col, _i} <- Enum.with_index(@col)}
                    class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800 dark:text-neutral-200"
                    phx-click={@row_click && @row_click.(row)}
                  >
                    {render_slot(col, @row_item.(row))}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :style, :atom, default: :solid, values: [:solid, :outline, :ghost, :soft, :white, :link]
  attr :size, :atom, default: :md, values: [:xs, :sm, :md, :lg]
  attr :class, :string, default: ""
  attr :rest, :global
  slot :inner_block, required: true

  def button(assigns) do
    styles = %{
      solid:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 focus:outline-hidden focus:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none",
      outline:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 text-gray-500 hover:border-blue-600 hover:text-blue-600 focus:outline-hidden focus:border-blue-600 focus:text-blue-600 disabled:opacity-50 disabled:pointer-events-none dark:border-neutral-700 dark:text-neutral-400 dark:hover:text-blue-500 dark:hover:border-blue-600 dark:focus:text-blue-500 dark:focus:border-blue-600",
      ghost:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent text-blue-600 hover:bg-blue-100 hover:text-blue-800 focus:outline-hidden focus:bg-blue-100 focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-500 dark:hover:bg-blue-800/30 dark:hover:text-blue-400 dark:focus:bg-blue-800/30 dark:focus:text-blue-400",
      soft:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-100 text-blue-800 hover:bg-blue-200 focus:outline-hidden focus:bg-blue-200 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-400 dark:hover:bg-blue-900 dark:focus:bg-blue-900",
      white:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 bg-white text-gray-800 shadow-2xs hover:bg-gray-50 focus:outline-hidden focus:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-white dark:hover:bg-neutral-700 dark:focus:bg-neutral-700",
      link:
        "inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent text-blue-600 hover:text-blue-800 focus:outline-hidden focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-500 dark:hover:text-blue-400 dark:focus:text-blue-400"
    }

    size_classes = %{xs: "py-1 px-1", sm: "py-2 px-3", md: "py-3 px-4", lg: "p-4 sm:p-5"}

    assigns =
      assign(assigns,
        btn_classes: Map.get(styles, assigns.style),
        size_class: Map.get(size_classes, assigns.size)
      )

    ~H"""
    <button type="button" class={[@btn_classes, @size_class, @class]} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
