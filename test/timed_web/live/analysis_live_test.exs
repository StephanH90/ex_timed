defmodule TimedWeb.AnalysisLiveTest do
  use TimedWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Timed.Tracking.Report

  test "it lists reports", %{conn: conn} do
    report = insert!(Report)
    {:ok, view, html} = live(conn, "/analysis")

    assert html =~ "Analysis"
    assert html =~ report.comment
  end

  test "it filters by customer", %{conn: conn} do
    report = insert!(Report)
    other_report = insert!(Report)
    {:ok, view, html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{customer_id: report.task.project.customer.id})

    assert has_element?(view, "tr", report.comment)
    refute has_element?(view, "tr", other_report.comment)
  end

  test "it filters by customer and task", %{conn: conn} do
    report = insert!(Report)
    other_report = insert!(Report)
    {:ok, view, html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{
      customer_id: report.task.project.customer.id,
      project_id: report.task.project.id
    })

    assert has_element?(view, "tr", report.comment)
    refute has_element?(view, "tr", other_report.comment)
  end
end
