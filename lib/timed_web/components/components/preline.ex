defmodule TimedWeb.Components.Preline do
  @moduledoc """
  Preline components
  """
  use Phoenix.Component
  use Gettext, backend: TimedWeb.Gettext
  import TimedWeb.CoreComponents, only: [icon: 1]

  # HEADERS
  slot :inner_block, required: true

  def h1(assigns) do
    ~H"""
    <h1 class="text-4xl dark:text-white">{render_slot(@inner_block)}</h1>
    """
  end

  slot :inner_block, required: true

  def h2(assigns) do
    ~H"""
    <h2 class="text-4xl dark:text-white">{render_slot(@inner_block)}</h2>
    """
  end

  slot :inner_block, required: true

  def h3(assigns) do
    ~H"""
    <h3 class="text-4xl dark:text-white">{render_slot(@inner_block)}</h3>
    """
  end

  slot :inner_block, required: true

  def h4(assigns) do
    ~H"""
    <h4 class="text-4xl dark:text-white">{render_slot(@inner_block)}</h4>
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
end
