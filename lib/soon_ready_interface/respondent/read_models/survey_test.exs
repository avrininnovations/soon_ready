defmodule SoonReadyInterface.Respondent.ReadModels.SurveyTest do
  use SoonReady.DataCase
  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReadyInterface.Respondent.ReadModels.Survey
  alias SoonReady.SurveyManagement.V1.DomainEvents.SurveyPublished

  setup do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, %{researcher_id: researcher_id} = command} = SoonReadyInterface.Admin.register_researcher(params)
    {:ok, user} = SoonReady.IdentityAndAccessManagement.Resources.User.sign_in_with_password(params.username, params.password)

    %{user: user}
  end

  test "GIVEN: An ODI survey was created, THEN: The survey is active", %{user: user} do
    screening_questions = [
      %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 1?", options: [
        %{type: "option_with_correct_flag", value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag", value: "Option 2", correct?: false},
      ]},
      %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 2?", options: [
        %{type: "option_with_correct_flag", value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag", value: "Option 2", correct?: false},
      ]}
    ]
    demographic_questions = [
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ]
    context_questions = [
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]

    {:ok, %{survey_id: survey_id, project_id: project_id} = _command} = SoonReadyInterface.Researcher.create_survey(%{
      brand_name: "A Big Brand",
      market: %{job_executor: "Persons", job_to_be_done: "Do what persons do"},
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
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
    })

    assert_receive_event(Application, SurveyPublished,
      fn event -> event.survey_id == survey_id end,
      fn event ->
        {:ok, event} = SurveyPublished.regenerate(event)
        {:ok, survey} = Survey.get_active(event.survey_id)

        assert survey.id == event.survey_id
        assert survey.starting_page_id == event.starting_page_id
        assert survey.pages == event.pages
        assert survey.is_active == true
      end
    )
  end
end
