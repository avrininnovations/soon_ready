defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ContactDetailsPageTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.LandingPageTest, as: LandingPage
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ScreeningQuestionsPageTest, as: ScreeningPage

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

  @form_params %{
    email: "hello@example.com",
    phone_number: "1234567890",
  }

  @expected_query_params %{
    "email" => "hello@example.com",
    "phone_number" => "1234567890"
  }

  test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their contact details, THEN: The demographics page is displayed", %{conn: conn} do
    with {:ok, survey} <- SoonReady.QuantifyingNeeds.Survey.create(@survey_params),
          {:ok, _survey} <- SoonReady.QuantifyingNeeds.Survey.publish(survey),
          {:ok, view, _html} <- live(conn, ~p"/survey/participate/#{survey.id}"),
          _ <- LandingPage.submit_response(view),
          _ <- assert_patch(view),
          _ <- ScreeningPage.submit_response(view),
          _ <- assert_patch(view)
    do
      _resulting_html = submit_response(view, @form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey.id}/demographics"
      assert has_element?(view, "h2", "Demographics")
      assert_query_params(path)
    else
      {:error, error} ->
        flunk("Error: #{inspect(error)}")
      _ ->
        flunk("An unexpected error occurred")
    end
  end

  def submit_response(view, params \\ @form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"contact_details_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @expected_query_params
  end
end