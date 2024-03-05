defmodule SoonReadyInterface.OdiSurveyCreationLive.DemographicQuestionsPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage
  alias SoonReadyInterface.OdiSurveyCreationLive.DesiredOutcomesPageTest, as: DesiredOutcomesPage
  alias SoonReadyInterface.OdiSurveyCreationLive.ScreeningQuestionsPageTest, as: ScreeningQuestionsPage

  @params %{"demographic_questions" => %{"0" => %{"prompt" => "Demographic Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Demographic Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}}

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two demographic questions, THEN: Two demographic question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)

      _resulting_html = add_two_demographic_questions(view)

      assert has_element?(view, ~s{input[name="form[demographic_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][prompt]"]})
    end

    test "GIVEN: Two demographic questions have been added, WHEN: Researcher tries to add two options each to the demographic questions, THEN: Two options field each are added to the demographic questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      add_two_demographic_questions(view)

      _resulting_html = add_two_options_each(view)

      assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][0][options][1][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[demographic_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two demographic questions, WHEN: Researcher tries to submit the demographic questions, THEN: The context questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      add_two_demographic_questions(view)
      add_two_options_each(view)

      _resulting_html = submit_form(view)

      _market_definition_page_path = assert_patch(view)
      _desired_outcomes_page_path = assert_patch(view)
      _screening_questions_page_path = assert_patch(view)
      _demographic_questions_page_path = assert_patch(view)
      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/context-questions"
      assert has_element?(view, "h2", "Context Questions")
      LandingPage.assert_query_params(path)
      MarketDefinitionPage.assert_query_params(path)
      DesiredOutcomesPage.assert_query_params(path)
      ScreeningQuestionsPage.assert_query_params(path)
      assert_query_params(path)
    end
  end

  def add_two_demographic_questions(view) do
    view
    |> element("button", "Add demographic question")
    |> render_click()

    view
    |> element("button", "Add demographic question")
    |> render_click()
  end

  def add_two_options_each(view) do
    view
    |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[demographic_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[demographic_questions][1]"]}, "Add option")
    |> render_click()
  end

  def submit_form(view) do
    view
    |> form("form", form: @params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"demographic_questions_form" => query_params} = Plug.Conn.Query.decode(query)
    assert SoonReady.Utils.is_equal_or_subset?(@params, query_params)
  end
end
