defmodule TimedWeb.Live.TrackingLiveTest do
  @moduledoc """
  Tests the tracking liveview page.
  """
  use TimedWeb.FeatureCase, async: true

  alias Timed.Employment.User
  alias Timed.Projects.Task
  alias Timed.Tracking.Report

  describe "editing a report" do
    test "saves the report", %{conn: conn} do
      report =
        insert!(Report,
          attrs: %{
            date: Date.utc_today(),
            duration: 15
          }
        )

      conn
      |> visit("/tracking")
      |> within("#report-#{report.id}", fn session ->
        session
        |> assert_has("input[name='comment'][value='#{report.comment}']")
        |> assert_has("input[name='duration'][value='00:15']")
        |> fill_in("Comment", with: "a new comment")
        |> fill_in("Duration", with: "30")
        |> click_button("[type=submit]", "")
        |> assert_has("input[name='comment'][value='a new comment']")
        |> assert_has("input[name='duration'][value='00:30']")
      end)
    end
  end

  describe "creating a new report" do
    test "saves the report", %{conn: conn} do
      # required for the weekly overview widget which is currenty hardcoded to look for the first user
      insert!(User)
      task = insert!(Task)

      conn
      |> visit("/tracking")
      |> assert_has("div[data-test-report-row]", count: 1)
      |> within("#report-new", fn session ->
        session
        |> click_link(task.project.customer.name)
        |> click_link(task.project.name)
        |> click_link(task.name)
        |> fill_in("Comment", with: "a new comment")
        |> fill_in("Duration", with: "30")
        |> click_button("submit")
      end)
      |> assert_has("div[data-test-report-row]", count: 2)
    end
  end

  describe "date navigation" do
    test "it navigates correctly", %{conn: conn} do
      # required for the weekly overview widget which is currenty hardcoded to look for the first user
      insert!(User)

      conn
      |> visit("/tracking")
      |> click_link("previous day")
      |> assert_path("/tracking",
        query_params: %{day: Date.utc_today() |> Date.add(-1) |> Date.to_iso8601()}
      )
      |> click_link("next day")
      |> assert_path("/tracking", query_params: %{day: Date.utc_today() |> Date.to_iso8601()})
      |> click_link("next day")
      |> assert_path("/tracking",
        query_params: %{day: Date.utc_today() |> Date.add(1) |> Date.to_iso8601()}
      )
    end
  end
end
