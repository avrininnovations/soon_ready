defmodule SoonReady.QuantifyingNeeds.Tests.SurveyTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.QuantifyingNeeds.Survey
  alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.{SurveyCreated, SurveyPublished}

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

  describe "Happy Path" do
    test "WHEN: A researcher tries to create a survey, THEN: A survey is created" do
      # TODO: Test the fact that the actor is an Avrin researcher

      case Survey.create(@survey_details) do
        {:ok, %{id: survey_id} = _aggregate} ->
          assert_receive_event(Application, SurveyCreated,
            fn event -> event.id == survey_id end,
            fn event ->
              assert SoonReady.Utils.is_equal_or_subset?(event.brand, @survey_details.brand)
              assert SoonReady.Utils.is_equal_or_subset?(event.market, @survey_details.market)
              assert SoonReady.Utils.is_equal_or_subset?(event.job_steps, @survey_details.job_steps)
              assert SoonReady.Utils.is_equal_or_subset?(event.screening_questions, @survey_details.screening_questions)
              assert SoonReady.Utils.is_equal_or_subset?(event.demographic_questions, @survey_details.demographic_questions)
              assert SoonReady.Utils.is_equal_or_subset?(event.context_questions, @survey_details.context_questions)
            end
          )
        {:error, error} ->
          flunk("Expected survey to be created but got: #{inspect(error)}")
      end
    end

    test "GIVEN: A survey has been created, WHEN: A researcher tries to publish the survey, THEN: The survey is published" do
      # TODO: Test the fact that the actor is an Avrin researcher

      with {:ok, %{id: survey_id} = survey} <- Survey.create(@survey_details) do
        case Survey.publish(survey) do
          {:ok, %{id: ^survey_id}} ->
            assert_receive_event(Application, SurveyPublished,
              fn event -> event.id == survey_id end,
              fn _event ->:ok end
            )
          {:error, error} ->
            flunk("Expected survey to be published but got: #{inspect(error)}")
        end
      end
    end
  end
end
