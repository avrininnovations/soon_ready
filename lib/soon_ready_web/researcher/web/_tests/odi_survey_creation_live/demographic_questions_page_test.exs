defmodule SoonReadyWeb.OdiSurveyCreationLive.DemographicQuestionsPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyWeb.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyWeb.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage
  alias SoonReadyWeb.OdiSurveyCreationLive.DesiredOutcomesPageTest, as: DesiredOutcomesPage
  alias SoonReadyWeb.OdiSurveyCreationLive.ScreeningQuestionsPageTest, as: ScreeningQuestionsPage

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two demographic questions, THEN: Two demographic question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)
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
      LandingPage.submit_brand_form(view)
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
      LandingPage.submit_brand_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      ScreeningQuestionsPage.add_two_screening_questions(view)
      ScreeningQuestionsPage.add_two_options_each(view)
      ScreeningQuestionsPage.submit_form(view)
      add_two_demographic_questions(view)
      add_two_options_each(view)

      resulting_html = submit_form(view)

      assert_patch(view, ~p"/odi-survey/create/context-questions")
      assert resulting_html =~ "Context Questions"
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
    |> form("form", form: %{demographic_questions: %{"0" => %{"prompt" => "Demographic Question 1", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}, "1" => %{"prompt" => "Demographic Question 2", "options" => %{"0" => %{"value" => "Option 1"}, "1" => %{"value" => "Option 2"}}}}})
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end
end
