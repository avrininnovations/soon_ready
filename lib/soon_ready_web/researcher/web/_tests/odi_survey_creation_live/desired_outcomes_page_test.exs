defmodule SoonReadyWeb.OdiSurveyCreationLive.DesiredOutcomesPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyWeb.OdiSurveyCreationLive.LandingPageTest, as: LandingPage
  alias SoonReadyWeb.OdiSurveyCreationLive.MarketDefinitionPageTest, as: MarketDefinitionPage

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Researcher tries to add two job steps, THEN: Two job step fields should be on the page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)
      MarketDefinitionPage.submit_form(view)

      resulting_html = add_two_job_steps(view)

      assert resulting_html =~ "Job Step 1"
      assert has_element?(view, ~s{input[name="form[job_steps][0][name]"]})
      assert resulting_html =~ "Job Step 2"
      assert has_element?(view, ~s{input[name="form[job_steps][1][name]"]})
    end

    test "GIVEN: Two job steps have been added, WHEN: Researcher tries to add two desired outcomes each to both job steps, THEN: Two desired outcome fields are added to the first job step", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)
      MarketDefinitionPage.submit_form(view)
      add_two_job_steps(view)

      _resulting_html = add_two_desired_outcomes_each(view)

      assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][0][value]"]})
      assert has_element?(view, ~s{input[name="form[job_steps][0][desired_outcomes][1][value]"]})
      assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][0][value]"]})
      assert has_element?(view, ~s{input[name="form[job_steps][1][desired_outcomes][1][value]"]})
    end

    test "GIVEN: Two desired outcome fields each have been added to two job steps, WHEN: Researcher tries to submit the desired outceoms, THEN: The screening question page is displayed", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/odi-survey/create")
      LandingPage.submit_brand_form(view)
      MarketDefinitionPage.submit_form(view)
      add_two_job_steps(view)
      add_two_desired_outcomes_each(view)

      resulting_html = submit_form(view)

      assert_patch(view, ~p"/odi-survey/create/screening-questions")
      assert resulting_html =~ "Screening Questions"
    end
  end

  def add_two_job_steps(view) do
    view
    |> element("button", "Add job step")
    |> render_click()

    view
    |> element("button", "Add job step")
    |> render_click()
  end

  def add_two_desired_outcomes_each(view) do
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
  end

  def submit_form(view) do
    view
    |> form("form", form: %{job_steps: %{"0" => %{"name" => "Job Step 1", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}, "1" => %{"name" => "Job Step 2", "desired_outcomes" => %{"0" => %{"value" => "Desired Outcome 1"}, "1" => %{"value" => "Desired Outcome 2"}}}}})
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end
end
