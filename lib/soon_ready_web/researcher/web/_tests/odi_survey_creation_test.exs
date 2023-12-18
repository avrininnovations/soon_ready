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
  end
end
