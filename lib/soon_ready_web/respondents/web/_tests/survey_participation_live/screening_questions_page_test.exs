defmodule SoonReadyWeb.Respondents.Web.Tests.SurveyParticipationLive.ScreeningQuestionsPageTest do
  use SoonReadyWeb.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReady.SurveyManagement.UseCases
  alias SoonReady.SurveyManagement.ValueObjects.OdiSurveyData

  alias SoonReadyWeb.Respondents.Web.Tests.SurveyParticipationLive.LandingPageTest, as: LandingPage

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

  @correct_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  describe "happy path" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to respond correctly to the screening questions, THEN: The contact details page is displayed", %{conn: conn} do
      with {:ok, odi_survey_data} <- OdiSurveyData.new(@survey_params),
            {:ok, use_case_data} <- UseCases.publish_odi_survey(odi_survey_data),
            {:ok, view, _html} = live(conn, ~p"/survey/participate/#{use_case_data.survey_id}"),
            _ = LandingPage.submit_form(view),
            _ = assert_patch(view)
      do
        resulting_html = submit_correct_response(view)

        path = assert_patch(view)
        assert path =~ ~p"/survey/participate/#{use_case_data.survey_id}/contact-details"
        assert resulting_html =~ "Contact Details"
        assert_query_params_has_correct_responses(path)
      else
        {:error, error} ->
          flunk("Error: #{inspect(error)}")
        _ ->
          flunk("An unexpected error occurred")
      end
    end
  end

  def submit_correct_response(view) do
    view
    |> form("form", form: @correct_form_params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_query_params_has_correct_responses(path) do
    %{query: query} = URI.parse(path)
    %{"screening_form" => query_params} = Plug.Conn.Query.decode(query)
    assert SoonReady.Utils.is_equal_or_subset?(@correct_form_params, query_params)
  end
end
