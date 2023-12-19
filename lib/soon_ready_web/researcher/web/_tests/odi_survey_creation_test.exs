defmodule SoonReadyWeb.OdiSurveyCreationTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "happy path" do
    test "WHEN: Researcher tries to visit the survey creation url, THEN: The landing page is displayed", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")

      assert html =~ "Welcome to the ODI Survey Creator!"
    end

    test "GIVEN: Researcher has visited the survey creation url, WHEN: Researcher tries to submit a brand name for the survey, THEN: The market definition page is displayed", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")

      resulting_html =
        view
        |> form("form", form: %{brand_name: "Big Brand Co"})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/market-definition")
      assert resulting_html =~ "Market Definition"
    end

    test "GIVEN: Brand name has been submitted, WHEN: Researcher tries to submit market definition details, THEN: The desrired outcomes page is displayed", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)

      resulting_html =
        view
        |> form("form", form: %{job_executor: "Person", job_to_be_done: "Do what persons do"})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/desired-outcomes")
      assert resulting_html =~ "Desired Outcomes"
    end

    test "GIVEN: Market definition details have been submitted, WHEN: Researcher tries to add two job steps, THEN: Two job step fields should be on the page", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)
      {:ok, view} = market_definition_details_have_been_submitted(view)

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
    end

    test "GIVEN: Two job steps have been added, WHEN: Researcher tries to add two desired outcomes each to both job steps, THEN: Two desired outcome fields are added to the first job step", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)
      {:ok, view} = market_definition_details_have_been_submitted(view)
      {:ok, view} = two_job_steps_have_been_added(view)

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
    end

    test "GIVEN: Two desired outcome fields each have been added to two job steps, WHEN: Researcher tries to submit the desired outceoms, THEN: The screening question page is displayed", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/odi-survey/create")
      {:ok, view} = brand_name_has_been_submitted(view)
      {:ok, view} = market_definition_details_have_been_submitted(view)
      {:ok, view} = two_job_steps_have_been_added(view)
      {:ok, view} = two_desired_outcomes_each_have_been_added(view)


      resulting_html =
        view
        # |> form("form", form: %{job_steps: [%{name: "Job Step 1", desired_outcomes: [%{value: "Desired Outcome 1"}, %{value: "Desired Outcome 2"}]}, %{name: "Job Step 2", desired_outcomes: [%{value: "Desired Outcome 1"}, %{value: "Desired Outcome 2"}]}]})
        |> form("form", form: %{job_steps: %{"0" => %{"name" => "Job Step 1", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}, "1" => %{"name" => "Job Step 2", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}}})
        |> put_submitter("button[name=submit]")
        |> render_submit()

      assert_patch(view, ~p"/odi-survey/create/screening-questions")
      assert resulting_html =~ "Screening Questions"
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
end
