defmodule SoonReady.QuantifyingNeeds.SurveyResponseTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.QuantifyingNeeds.Survey
  alias SoonReady.QuantifyingNeeds.SurveyResponse
  alias SoonReady.QuantifyingNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted

  @survey_details %{
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

  @survey_response_details %{
    participant: %{
      nickname: "Participant 1",
      email: "demo@example.com",
      phone_number: "555-555-5555"
    },
    screening_responses: [
      %{prompt: "What is the answer to screening question 1?", response: "Option 1"},
      %{prompt: "What is the answer to screening question 2?", response: "Option 1"}
    ],
    demographic_responses: [
      %{prompt: "What is the answer to demographic question 1?", response: "Option 1"},
      %{prompt: "What is the answer to demographic question 2?", response: "Option 1"}
    ],
    context_responses: [
      %{prompt: "What is the answer to context question 1?", response: "Option 1"},
      %{prompt: "What is the answer to context question 2?", response: "Option 1"}
    ],
    comparison_responses: [
      %{prompt: "What products, services or platforms have you used to do what persons do?", response: "Product 1, Service 2, Platform 3"},
      %{prompt: "What additional things do you usually use/require when you're using any of the above?", response: "Thing 1, Thing 2"},
      %{prompt: "In total, how much would you estimate that you spend annually to do what persons do?", response: "1000"},
      %{prompt: "Would you be willing to pay more for a better solution?", response: "Yes"},
      %{prompt: "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", response: "1000"},
    ],
    desired_outcome_ratings: [
      %{name: "Job Step 1", desired_outcomes: [
        %{name: "Minimize the time it takes to do A", importance: "Very Important", satisfaction: "Very Satisfied"},
        %{name: "Minimize the likelihood that B occurs", importance: "Somewhat Important", satisfaction: "Satisfied"},
      ]},
      %{name: "Job Step 2", desired_outcomes: [
        %{name: "Minimize the time it takes to do C", importance: "Not At All Important", satisfaction: "Extremely Satisfied"},
        %{name: "Minimize the likelihood that D occurs", importance: "Important", satisfaction: "Somewhat Satisfied"},
      ]},
    ]
  }

  describe "Happy Path" do
    test "GIVEN: A survey has been published, WHEN: A participant tries to submit a survey response, THEN: A survey response is submitted" do
      with {:ok, %{id: survey_id} = survey} <- Survey.create_survey(@survey_details),
            {:ok, ^survey} <- Survey.publish_survey(%{id: survey_id})
      do
        # TODO: Test the fact that the actor is a participant

        @survey_response_details
        |> Map.put(:survey_id, survey_id)
        |> SurveyResponse.submit_response()
        |> case do
          {:ok, %{id: survey_response_id} = _aggregate} ->
            assert_receive_event(Application, SurveyResponseSubmitted,
              fn event -> event.id == survey_response_id end,
              fn event ->
                decrypted_participant = SurveyResponse.decrypt_participant_details(event.id, event.participant)

                assert event.survey_id == survey_id
                assert decrypted_participant.nickname == @survey_response_details.participant.nickname
                assert decrypted_participant.email == @survey_response_details.participant.email
                assert decrypted_participant.phone_number == @survey_response_details.participant.phone_number
                assert SoonReady.Utils.is_equal_or_subset?(event.screening_responses, @survey_response_details.screening_responses)
                assert SoonReady.Utils.is_equal_or_subset?(event.demographic_responses, @survey_response_details.demographic_responses)
                assert SoonReady.Utils.is_equal_or_subset?(event.context_responses, @survey_response_details.context_responses)
                assert SoonReady.Utils.is_equal_or_subset?(event.comparison_responses, @survey_response_details.comparison_responses)
                assert SoonReady.Utils.is_equal_or_subset?(event.desired_outcome_ratings, @survey_response_details.desired_outcome_ratings)
              end
            )
          {:error, error} ->
            flunk("Expected survey response to be submitted but got: #{inspect(error)}")
        end
      end
    end
  end
end
