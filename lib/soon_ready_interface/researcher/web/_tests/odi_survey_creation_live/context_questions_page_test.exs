defmodule SoonReadyInterface.OdiSurveyCreationLive.ContextQuestionsPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage
  alias SoonReadyInterface.OdiSurveyCreationLive.DesiredOutcomesPageTest, as: DesiredOutcomesPage
  alias SoonReadyInterface.OdiSurveyCreationLive.ScreeningQuestionsPageTest, as: ScreeningQuestionsPage
  alias SoonReadyInterface.OdiSurveyCreationLive.DemographicQuestionsPageTest, as: DemographicQuestionsPage

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two context questions, THEN: Two context question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      DemographicQuestionsPage.add_two_demographic_questions(view)
      DemographicQuestionsPage.add_two_options_each(view)
      DemographicQuestionsPage.submit_form(view)

      _resulting_html = add_two_context_questions(view)

      assert has_element?(view, ~s{input[name="form[context_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][prompt]"]})
    end

    test "GIVEN: Two context questions have been added, WHEN: Researcher tries to add two options each to the context questions, THEN: Two options field each are added to the context questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      DemographicQuestionsPage.add_two_demographic_questions(view)
      DemographicQuestionsPage.add_two_options_each(view)
      DemographicQuestionsPage.submit_form(view)
      add_two_context_questions(view)

      _resulting_html = add_two_options_each(view)

      assert has_element?(view, ~s{input[name="form[context_questions][0][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][0][options][1][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][options][0][value]"]})
      assert has_element?(view, ~s{input[name="form[context_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two context questions, WHEN: Researcher tries to submit the context questions, THEN: The context questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      DemographicQuestionsPage.add_two_demographic_questions(view)
      DemographicQuestionsPage.add_two_options_each(view)
      DemographicQuestionsPage.submit_form(view)
      add_two_context_questions(view)
      add_two_options_each(view)

      _resulting_html = submit_form(view)

      flash = assert_redirect(view, ~p"/")
      assert flash == %{"info" => "Survey created successfully!"}
    end
  end

  def add_two_context_questions(view) do
    view
    |> element("button", "Add context question")
    |> render_click()

    view
    |> element("button", "Add context question")
    |> render_click()
  end

  def add_two_options_each(view) do
    view
    |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[context_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[context_questions][1]"]}, "Add option")
    |> render_click()
  end

  def submit_form(view) do
    view
    |> form("form", form: %{context_questions: %{"0" => %{"prompt" => "Context Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Context Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}})
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end
end
