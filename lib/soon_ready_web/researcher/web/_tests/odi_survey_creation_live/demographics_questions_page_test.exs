defmodule SoonReadyWeb.OdiSurveyCreationLive.DemographicsQuestionsPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two demographics questions, THEN: Two demographics question fields are added", %{conn: conn} do
      {:ok, view, html} = forms_in_previous_pages_have_been_filled(conn, ~p"/odi-survey/create")

      view
      |> element("button", "Add demographics question")
      |> render_click()

      resulting_html =
        view
        |> element("button", "Add demographics question")
        |> render_click()

      assert has_element?(view, ~s{input[name="form[demographics_questions][0][prompt]"]})
      assert has_element?(view, ~s{input[name="form[demographics_questions][1][prompt]"]})
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

    view
    |> element("button", "Add screening question")
    |> render_click()

    resulting_html =
      view
      |> element("button", "Add screening question")
      |> render_click()

    assert has_element?(view, ~s{input[name="form[screening_questions][0][prompt]"]})
    assert has_element?(view, ~s{input[name="form[screening_questions][1][prompt]"]})

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


    resulting_html =
      view
      |> form("form", form: %{screening_questions: %{"0" => %{"prompt" => "Screening Question 1", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}, "1" => %{"prompt" => "Screening Question 2", "options" => %{"0" => %{"is_correct_option" => "true", "value" => "Option 1"}, "1" => %{"is_correct_option" => "false", "value" => "Option 2"}}}}})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/demographics-questions")
    assert resulting_html =~ "Demographics Questions"

    {:ok, view, resulting_html}
  end
end
