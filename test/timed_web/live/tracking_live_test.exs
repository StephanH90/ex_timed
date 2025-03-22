defmodule TimedWeb.AdminCanCreateUserTest do
  use TimedWeb.FeatureCase, async: true

  use Timed.Test.Factories

  alias Timed.Tracking.Report
  alias Timed.Projects.Costcenter
  alias Timed.Projects.Task

  test "test", %{conn: conn} do
    [report | _other_reports] = insert!(Report, count: 1)

    conn
    |> visit("/tracking")
    |> within("#report-#{report.id}", fn session ->
      session
      |> fill_in("Comment", with: "a new comment")
      |> open_browser()
      |> click_button("[type=submit]", "")
      |> open_browser()
    end)
  end
end
