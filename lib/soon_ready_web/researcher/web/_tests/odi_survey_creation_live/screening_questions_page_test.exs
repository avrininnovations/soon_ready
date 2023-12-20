defmodule SoonReadyWeb.OdiSurveyCreationLive.ScreeningQuestionsPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "GIVEN: Desired outcomes have been submitted, WHEN: Researcher tries to add two screening questions, THEN: Two screening question fields are added", %{conn: conn} do
      {:ok, view, html} = forms_in_previous_pages_have_been_filled(conn, ~p"/odi-survey/create")

      view
      |> element("button", "Add screening question")
      |> render_click()

      resulting_html =
        view
        |> element("button", "Add screening question")
        |> render_click()

      assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})
    end

    test "GIVEN: Two screening questions have been added, WHEN: Researcher tries to add two options each to the screening questions, THEN: Two options field each are added to the screening questions", %{conn: conn} do
      {:ok, view, html} = forms_in_previous_pages_have_been_filled(conn, ~p"/odi-survey/create")
      {:ok, view} = two_screening_questions_have_been_added(view)


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
    end

    test "GIVEN: Two options each have been added to two screening questions, WHEN: Researcher tries to submit the screening questions, THEN: The demographics questions page is displayed", %{conn: conn} do
      {:ok, view, html} = forms_in_previous_pages_have_been_filled(conn, ~p"/odi-survey/create")
      {:ok, view} = two_screening_questions_have_been_added(view)
      {:ok, view} = two_options_each_have_been_added(view)

      resulting_html =
        view
        |> form("form", form: %{screening_questions: %{"0" => %{"prompt" => "Screening Question 1", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}, "1" => %{"prompt" => "Screening Question 2", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}}})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/demographics-questions")
      assert resulting_html =~ "Demographics Questions"
    end
  end

  defp forms_in_previous_pages_have_been_filled(conn, path) do
    {:ok, view, _html} = live(conn, path)

    resulting_html =
      view
      |> form("form", form: %{brand_name: "Big Brand Co"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/market-definition")
    assert resulting_html =~ "Market Definition"

    resulting_html =
      view
      |> form("form", form: %{job_executor: "Person", job_to_be_done: "Do what persons do"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
    assert resulting_html =~ "Desired Outcomes"

    view
    |> element("button", "Add job step")
    |> render_click()

    resulting_html =
      view
      |> element("button", "Add job step")
      |> render_click()

    assert resulting_html =~ "Job Step 1"
    assert has_element?(view, ~s{input[name="form[job_steps][0][name]"]})
    assert resulting_html =~ "Job Step 2"
    assert has_element?(view, ~s{input[name="form[job_steps][1][name]"]})

    view
    |> element(~s{button[name="form[job_steps][0]"]}, "Add desired outcome")
    |> render_click()

    view
    |> element(~s{button[name="form[job_steps][0]"]}, "Add desired outcome")
    |> render_click()

    view
    |> element(~s{button[name="form[job_steps][1]"]}, "Add desired outcome")
    |> render_click()

    view
    |> element(~s{button[name="form[job_steps][1]"]}, "Add desired outcome")
    |> render_click()

    assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][0][value]"]})
    assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][1][value]"]})
    assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][0][value]"]})
    assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][1][value]"]})

    resulting_html =
      view
      |> form("form", form: %{job_steps: %{"0" => %{"name" => "Job Step 1", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}, "1" => %{"name" => "Job Step 2", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}}})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/screening-questions")
    assert resulting_html =~ "Screening Questions"

    {:ok, view, resulting_html}
  end

  defp two_screening_questions_have_been_added(view) do
    view
    |> element("button", "Add screening question")
    |> render_click()

    resulting_html =
      view
      |> element("button", "Add screening question")
      |> render_click()

    assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})

    {:ok, view}
  end

  def two_options_each_have_been_added(view) do
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
end
