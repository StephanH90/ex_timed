defmodule TimedWeb.LayoutHooks do
  @moduledoc """
  On mount hook for layout components. Sets the `:current_path` assigns based on the request URI.
  """
  # import Phoenix.Component
  import Phoenix.LiveView, only: [attach_hook: 4]
  use TimedWeb, :html

  def on_mount(:on_mount, _params, _session, socket) do
    {:cont, attach_hook(socket, :current_page, :handle_params, &set_current_url/3)}
  end

  defp set_current_url(_params, uri, socket) do
    {:cont, assign(socket, :current_uri, URI.parse(uri) |> Map.get(:path))}
  end
end
