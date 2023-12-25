defmodule SoonReadyWeb.OdiSurveyCreationLive.MarketDefinitionPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyWeb.OdiSurveyCreationLive.LandingPageTest, as: LandingPage

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)

      resulting_html = submit_form(view)

      assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
      assert resulting_html =~ "Desired Outcomes"
    end
  end

  def submit_form(view) do
    view
    |> form("form", form: %{job_executor: "Person", job_to_be_done: "Do what persons do"})
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end
end
