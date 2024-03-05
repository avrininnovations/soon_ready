defmodule SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage

  @params %{job_executor: "Person", job_to_be_done: "Do what persons do"}

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)

      _resulting_html = submit_form(view)

      _market_definition_page_path = assert_patch(view)
      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/desired-outcomes"
      assert has_element?(view, "h2", "Desired Outcomes")
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
    %{"market_definition_form" => %{
      "job_executor" => job_executor,
      "job_to_be_done" => job_to_be_done
    }} = Plug.Conn.Query.decode(query)
    assert job_executor == @params[:job_executor]
    assert job_to_be_done == @params[:job_to_be_done]
  end
end
