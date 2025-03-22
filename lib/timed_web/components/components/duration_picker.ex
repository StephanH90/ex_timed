defmodule TimedWeb.Components.DurationPicker do
  @moduledoc """
  A component that renders a duration picker input field.
  Provides additonal functionality like arrows up and down to increase or decrease the duration.
  """
  use TimedWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> parse_duration()
    }
  end

  defp parse_duration(socket) do
    duration_as_string = Timed.DurationFormatter.format(socket.assigns.value)
    assign(socket, :duration, duration_as_string)
  end

  attr :field, Phoenix.HTML.FormField, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.input
        phx-target={@myself}
        value={@duration}
        id={@field.name}
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
        phx-debounce="blur"
        phx-hook="DurationPicker"
        data-raw-minutes={Timed.DurationFormatter.to_minutes(@field.value)}
      />
    </div>
    """
  end
end
