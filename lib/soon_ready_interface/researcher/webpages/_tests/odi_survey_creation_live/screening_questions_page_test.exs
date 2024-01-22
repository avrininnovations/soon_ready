defmodule SoonReadyInterface.OdiSurveyCreationLive.ScreeningQuestionsPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage
  alias SoonReadyInterface.OdiSurveyCreationLive.DesiredOutcomesPageTest, as: DesiredOutcomesPage

  @params %{"screening_questions" => %{"0" => %{"prompt" => "Screening Question 1", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}, "1" => %{"prompt" => "Screening Question 2", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}}}

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two screening questions, THEN: Two screening question fields are added", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)

      _resulting_html = add_two_screening_questions(view)

      assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})
    end

    test "GIVEN: Two screening questions have been added, WHEN: Researcher tries to add two options each to the screening questions, THEN: Two options field each are added to the screening questions", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)

      _resulting_html = add_two_options_each(view)

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})
    end

    test "GIVEN: Two options each have been added to two screening questions, WHEN: Researcher tries to submit the screening questions, THEN: The demographic questions page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_form(view)
      MarketDefinitionPage.submit_form(view)
      DesiredOutcomesPage.add_two_job_steps(view)
      DesiredOutcomesPage.add_two_desired_outcomes_each(view)
      DesiredOutcomesPage.submit_form(view)
      add_two_screening_questions(view)
      add_two_options_each(view)

      resulting_html = submit_form(view)

      _market_definition_page_path = assert_patch(view)
      _desired_outcomes_page_path = assert_patch(view)
      _screening_questions_page_path = assert_patch(view)
      path = assert_patch(view)
      assert path =~ ~p"/odi-survey/create/demographic-questions"
      assert resulting_html =~ "Demographic Questions"
      LandingPage.assert_query_params(path)
      MarketDefinitionPage.assert_query_params(path)
      DesiredOutcomesPage.assert_query_params(path)
      assert_query_params(path)
    end
  end

  def add_two_screening_questions(view) do
    view
    |> element("button", "Add screening question")
    |> render_click()

    view
    |> element("button", "Add screening question")
    |> render_click()
  end

  def add_two_options_each(view) do
    view
    |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[screening_questions][0]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
    |> render_click()

    view
    |> element(~s{button[name="form[screening_questions][1]"]}, "Add option")
    |> render_click()

    assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][is_correct_option]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][0][options][0][value]"]})

    assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][is_correct_option]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][0][options][1][value]"]})

    assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][is_correct_option]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][1][options][0][value]"]})

    assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][is_correct_option]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][1][options][1][value]"]})

    {:ok, view}
  end

  def submit_form(view) do
    view
    |> form("form", form: @params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"screening_questions_form" => query_params} = Plug.Conn.Query.decode(query)
    assert SoonReady.Utils.is_equal_or_subset?(@params, query_params)
  end
end
