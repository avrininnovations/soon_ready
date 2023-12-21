defmodule SoonReadyWeb.OdiSurveyCreationLive.LandingPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "WHEN: Researcher tries to visit the survey creation url, THEN: The landing page is displayed", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/odi-survey/create")

      assert html =~ "Welcome to the ODI Survey Creator!"
    end

    test "GIVEN: Researcher has visited the survey creation url, WHEN: Researcher tries to submit a brand name for the survey, THEN: The market definition page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")

      resulting_html =
        view
        |> form("form", form: %{brand_name: "Big Brand Co"})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/market-definition")
      assert resulting_html =~ "Market Definition"
    end
  end
end
