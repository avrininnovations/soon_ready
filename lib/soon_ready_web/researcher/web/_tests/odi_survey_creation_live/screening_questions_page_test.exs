defmodule SoonReadyWeb.OdiSurveyCreationLive.ScreeningQuestionsPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "GIVEN: Desired outcomes have been submitted, WHEN: Researcher tries to add two screening questions, THEN: Two screening question fields are added", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)
      {:ok, view} = market_definition_details_have_been_submitted(view)
      {:ok, view} = two_job_steps_have_been_added(view)
      {:ok, view} = two_desired_outcomes_each_have_been_added(view)
      {:ok, view} = desired_outcomes_have_been_submitted(view)

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
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)
      {:ok, view} = market_definition_details_have_been_submitted(view)
      {:ok, view} = two_job_steps_have_been_added(view)
      {:ok, view} = two_desired_outcomes_each_have_been_added(view)
      {:ok, view} = desired_outcomes_have_been_submitted(view)
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
  end

  defp brand_name_has_been_submitted(view) do
    resulting_html =
      view
      |> form("form", form: %{brand_name: "Big Brand Co"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/market-definition")
    assert resulting_html =~ "Market Definition"

    {:ok, view}
  end

  defp market_definition_details_have_been_submitted(view) do
    resulting_html =
      view
      |> form("form", form: %{job_executor: "Person", job_to_be_done: "Do what persons do"})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
    assert resulting_html =~ "Desired Outcomes"

    {:ok, view}
  end

  defp two_job_steps_have_been_added(view) do
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

    {:ok, view}
  end

  defp two_desired_outcomes_each_have_been_added(view) do
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

    {:ok, view}
  end

  defp desired_outcomes_have_been_submitted(view) do
    resulting_html =
      view
      |> form("form", form: %{job_steps: %{"0" => %{"name" => "Job Step 1", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}, "1" => %{"name" => "Job Step 2", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}}})
      |> put_submitter("button[name=submit]")
      |> render_submit()

    assert_patch(view, ~p"/odi-survey/create/screening-questions")
    assert resulting_html =~ "Screening Questions"

    {:ok, view}
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
end
