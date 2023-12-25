defmodule SoonReadyWeb.OdiSurveyCreationLive.MarketDefinitionPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyWeb.OdiSurveyCreationLive.LandingPageTest, as: LandingPage

  @params %{job_executor: "Person", job_to_be_done: "Do what persons do"}
  
  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)
      assert_patch(view)

      resulting_html = submit_form(view)

      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/desired-outcomes"
      assert resulting_html =~ "Desired Outcomes"
      LandingPage.assert_query_params(path)
      assert_query_params(path)
    end
  end

  def submit_form(view) do
    view
    |> form("form", form: @params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    query_params = URI.decode_query(query)
    assert query_params["market_definition_form[job_executor]"] == @params[:job_executor]
    assert query_params["market_definition_form[job_to_be_done]"] == @params[:job_to_be_done]
  end
end
