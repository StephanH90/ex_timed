defmodule TimedWeb.PageController do
  use TimedWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/tracking")
  end
end
