defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLiveTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ScreeningQuestionsPageTest, as: ScreeningPage
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ContactDetailsPageTest, as: ContactDetailsPage
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.DemographicsPageTest, as: DemographicsPage

  @survey_params %{
    brand: "A Big Brand",
    market: %{
      job_executor: "Persons",
      job_to_be_done: "Do what persons do"
    },
    job_steps: [
      %{name: "Job Step 1", desired_outcomes: [
        "Minimize the time it takes to do A",
        "Minimize the likelihood that B occurs"
      ]},
      %{name: "Job Step 2", desired_outcomes: [
        "Minimize the time it takes to do C",
        "Minimize the likelihood that D occurs"
      ]},
    ],
    screening_questions: [
      %{prompt: "What is the answer to screening question 1?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]},
      %{prompt: "What is the answer to screening question 2?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]}
    ],
    demographic_questions: [
      %{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ],
    context_questions: [
      %{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]
  }

  @desired_outcome_form_params %{
    "job_steps" => %{
      "0" => %{
        "desired_outcomes" => %{
          "0" => %{"importance" => "Very Important", "satisfaction" => "Very Satisfied"},
          "1" => %{"importance" => "Somewhat Important", "satisfaction" => "Satisfied"},
        }
      },
      "1" => %{
        "desired_outcomes" => %{
          "0" => %{"importance" => "Not At All Important", "satisfaction" => "Extremely Satisfied"},
          "1" => %{"importance" => "Important", "satisfaction" => "Somewhat Satisfied"},
        }
      },
    }
  }

  @comparison_form_params %{
    alternatives_used: "Product 1, Service 2, Platform 3",
    additional_resources_used: "Thing 1, Thing 2",
    amount_spent_annually_in_naira: "1000",
    is_willing_to_pay_more: "Yes",
    extra_amount_willing_to_pay_in_naira: "1000",
  }

  @comparison_page_query_params %{
    "0" => %{"prompt" => "What products, services or platforms have you used to do what persons do?", "response" => "Product 1, Service 2, Platform 3"},
    "1" => %{"prompt" => "What additional things do you usually use/require when you're using any of the above?", "response" => "Thing 1, Thing 2"},
    "2" => %{"prompt" => "In total, how much would you estimate that you spend annually to do what persons do?", "response" => "1000"},
    "3" => %{"prompt" => "Would you be willing to pay more for a better solution?", "response" => "Yes"},
    "4" => %{"prompt" => "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", "response" => "1000"}
  }

  @context_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @context_page_query_params %{
    "0" => %{"prompt" => "What is the answer to context question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to context question 2?", "response" => "Option 1"}
  }

  @demographics_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @demographics_page_query_params %{
    "0" => %{"prompt" => "What is the answer to demographic question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to demographic question 2?", "response" => "Option 1"}
  }


  def submit_desired_outcome_rating_form_response(view, params \\ @desired_outcome_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def submit_comparison_form_response(view, params \\ @comparison_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_comparison_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"comparison_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @comparison_page_query_params
  end

  def submit_context_form_response(view, params \\ @context_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_context_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"context_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @context_page_query_params
  end

  def submit_demographics_form_response(view, params \\ @demographics_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_demographics_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"demographics_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @demographics_page_query_params
  end

  describe "Demographics Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their demographic details, THEN: The context page is displayed", %{conn: conn} do
      with {:ok, survey} <- SoonReady.QuantifyingNeeds.Survey.create(@survey_params),
            {:ok, _survey} <- SoonReady.QuantifyingNeeds.Survey.publish(survey),
            {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{survey.id}"),
            _ <- LandingPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ScreeningPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ContactDetailsPage.submit_response(view),
            _ <- assert_patch(view)
      do
        _resulting_html = submit_demographics_form_response(view, @demographics_form_params)

        path = assert_patch(view)
        assert path =~ ~p"/survey/participate/#{survey.id}/context"
        assert has_element?(view, "h2", "Context")
        assert_demographics_page_query_params(path)
      else
        {:error, error} ->
          flunk("Error: #{inspect(error)}")
        _ ->
          flunk("An unexpected error occurred")
      end
    end
  end

  describe "Context Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their context details, THEN: The comparison page is displayed", %{conn: conn} do
      with {:ok, survey} <- SoonReady.QuantifyingNeeds.Survey.create(@survey_params),
            {:ok, _survey} <- SoonReady.QuantifyingNeeds.Survey.publish(survey),
            {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{survey.id}"),
            _ <- LandingPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ScreeningPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ContactDetailsPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- submit_demographics_form_response(view),
            _ <- assert_patch(view)
      do
        _resulting_html = submit_context_form_response(view, @context_form_params)

        path = assert_patch(view)
        assert path =~ ~p"/survey/participate/#{survey.id}/comparison"
        assert has_element?(view, "h2", "Comparison")
        assert_context_page_query_params(path)
      else
        {:error, error} ->
          flunk("Error: #{inspect(error)}")
        _ ->
          flunk("An unexpected error occurred")
      end
    end
  end

  describe "Comparison Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their comparison details, THEN: The desired outcome rating page is displayed", %{conn: conn} do
      with {:ok, survey} <- SoonReady.QuantifyingNeeds.Survey.create(@survey_params),
            {:ok, _survey} <- SoonReady.QuantifyingNeeds.Survey.publish(survey),
            {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{survey.id}"),
            _ <- LandingPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ScreeningPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ContactDetailsPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- submit_demographics_form_response(view),
            _ <- assert_patch(view),
            _ <- submit_context_form_response(view),
            _ <- assert_patch(view)
      do
        _resulting_html = submit_comparison_form_response(view, @comparison_form_params)

        path = assert_patch(view)
        assert path =~ ~p"/survey/participate/#{survey.id}/desired-outcome-ratings"
        assert has_element?(view, "h2", "Desired Outcome Ratings")
        assert_comparison_page_query_params(path)
      else
        {:error, error} ->
          flunk("Error: #{inspect(error)}")
        _ ->
          flunk("An unexpected error occurred")
      end
    end
  end

  describe "Desired Outcome Rating Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their desired outcome ratings, THEN: The thank you page is displayed", %{conn: conn} do
      with {:ok, survey} <- SoonReady.QuantifyingNeeds.Survey.create(@survey_params),
            {:ok, _survey} <- SoonReady.QuantifyingNeeds.Survey.publish(survey),
            {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{survey.id}"),
            _ <- LandingPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ScreeningPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- ContactDetailsPage.submit_response(view),
            _ <- assert_patch(view),
            _ <- submit_demographics_form_response(view),
            _ <- assert_patch(view),
            _ <- submit_context_form_response(view),
            _ <- assert_patch(view),
            _ <- submit_comparison_form_response(view),
            _ <- assert_patch(view)
      do
        _resulting_html = submit_desired_outcome_rating_form_response(view, @desired_outcome_form_params)

        path = assert_patch(view)
        assert path =~ ~p"/survey/participate/#{survey.id}/thank-you"
        assert has_element?(view, "h2", "Thank You!")
      else
        {:error, error} ->
          flunk("Error: #{inspect(error)}")
        _ ->
          flunk("An unexpected error occurred")
      end
    end
  end
end
