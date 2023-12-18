defmodule SoonReadyWeb.OdiSurveyCreationTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  test "WHEN: Researcher submits correct details in each page, THEN: Survey is published", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/odi-survey/create")

    assert html =~ "Welcome to the ODI Survey Creator!"

    resulting_html =
      view
      |> element("button", "Start Your Adventure")
      |> render_click()

    assert_patch(view, ~p"/odi-survey/create/market-definition")
    assert resulting_html =~ "Market Definition"

    resulting_html =
      view
      |> form("form", form: %{brand_name: "Big Brand Co", job_executor: "Person", job_to_be_done: "Do what persons do"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
    assert resulting_html =~ "Desired Outcomes"
  end
end
