defmodule SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "WHEN: Researcher tries to visit the survey creation url, THEN: The landing page is displayed", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/odi-survey/create")

      assert html =~ "Welcome to the ODI Survey Creator!"
    end

    @params %{brand_name: "Big Brand Co"}

    test "GIVEN: Researcher has visited the survey creation url, WHEN: Researcher tries to submit a brand name for the survey, THEN: The market definition page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")

      resulting_html = submit_form(view)

      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/market-definition"
      assert resulting_html =~ "Market Definition"
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
    %{"brand_name_form" => %{"brand_name" => brand_name}} = Plug.Conn.Query.decode(query)
    assert brand_name == @params[:brand_name]
  end
end
