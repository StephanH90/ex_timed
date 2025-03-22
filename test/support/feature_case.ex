defmodule TimedWeb.FeatureCase do
  @moduledoc """
  This module defines the test case to be used with PhoenixTest
  to easily test Liveviews.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use TimedWeb, :verified_routes

      import TimedWeb.FeatureCase

      import PhoenixTest
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Timed.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
