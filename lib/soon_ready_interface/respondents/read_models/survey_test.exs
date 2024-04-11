defmodule SoonReadyInterface.Respondents.ReadModels.SurveyTest do
  use SoonReady.DataCase

  alias SoonReady.QuantifyingNeeds.Survey
  alias SoonReadyInterface.Respondents.ReadModels.Survey, as: SurveyReadModel

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
    with {:ok, user} <- SoonReady.UserAuthentication.UserAccount.register_user_with_password("marty", "outatime1985", "outatime1985"),
          {:ok, %{survey_id: survey_id}} <- Survey.create_survey(@survey_params, user),
          {:ok, _survey} <- Survey.publish_survey(%{survey_id: survey_id})
    do
      {:ok, survey} = SurveyReadModel.get_active(survey_id)
      assert survey.id == survey_id
    else
      {:error, error} ->
        flunk("Expected survey to be created and published but got: #{inspect(error)}")
    end
  end
end
