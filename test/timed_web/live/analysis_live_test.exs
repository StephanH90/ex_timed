defmodule TimedWeb.AnalysisLiveTest do
  use TimedWeb.ConnCase
  import Phoenix.LiveViewTest
  alias Timed.Tracking.Report
  alias Timed.Projects.Task

  test "it lists reports", %{conn: conn} do
    report = insert!(Report)
    {:ok, _view, html} = live(conn, "/analysis")

    assert html =~ "Analysis"
    assert html =~ report.comment
  end

  test "it filters by customer", %{conn: conn} do
    report = insert!(Report)
    other_report = insert!(Report)
    {:ok, view, _html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{customer_id: report.task.project.customer.id})

    assert has_element?(view, "tr", report.comment)
    refute has_element?(view, "tr", other_report.comment)
  end

  test "it filters by project", %{conn: conn} do
    report = insert!(Report)
    report_with_same_project = insert!(Report, relate: [task: report.task])
    other_report = insert!(Report)

    {:ok, view, _html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{
      customer_id: report.task.project.customer.id,
      project_id: report.task.project.id
    })

    assert has_element?(view, "tr", report.comment)
    assert has_element?(view, "tr", report_with_same_project.comment)
    refute has_element?(view, "tr", other_report.comment)
  end

  test "it filters by task", %{conn: conn} do
    report = insert!(Report)
    other_task_with_same_project = insert!(Task, relate: [project: report.task.project])

    report_with_same_project_but_different_task =
      insert!(Report, relate: [task: other_task_with_same_project])

    other_report = insert!(Report)

    {:ok, view, _html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{
      customer_id: report.task.project.customer.id,
      project_id: report.task.project.id,
      task_id: report.task.id
    })

    assert has_element?(view, "tr", report.comment)
    refute has_element?(view, "tr", report_with_same_project_but_different_task.comment)
    refute has_element?(view, "tr", other_report.comment)
  end

  test "it filters by comment", %{conn: conn} do
    report_1 = insert!(Report, attrs: %{comment: "foo"})
    report_2 = insert!(Report, attrs: %{comment: "bar"})

    {:ok, view, html} = live(conn, "/analysis")

    view
    |> form("#filters")
    |> render_change(%{
      comment: "foo"
    })

    assert has_element?(view, "tr", report_1.comment)
    refute has_element?(view, "tr", report_2.comment)
  end
end
