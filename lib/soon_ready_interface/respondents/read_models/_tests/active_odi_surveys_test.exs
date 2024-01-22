defmodule SoonReadyInterface.Respondents.ReadModels.Tests.ActiveOdiSurveysTest do
  use SoonReady.DataCase

  alias SoonReady.QuantifyNeeds.Survey.Commands.PublishOdiSurvey
  alias SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys

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

  test "GIVEN: An ODI survey was publised, THEN: The survey is active" do
    {:ok, command} = PublishOdiSurvey.dispatch(@survey_params)

    {:ok, survey} = ActiveOdiSurveys.get(command.survey_id)
    assert survey.id == command.survey_id
  end
end
