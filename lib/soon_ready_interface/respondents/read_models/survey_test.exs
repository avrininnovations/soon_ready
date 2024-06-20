defmodule SoonReadyInterface.Respondents.ReadModels.SurveyTest do
  use SoonReady.DataCase
  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReadyInterface.Respondents.ReadModels.Survey
  alias SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationSucceededV1


  @survey_params %{
    survey_id: Ecto.UUID.generate(),
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
      %{type: "multiple_choice_question", prompt: "What is the answer to screening question 1?", options: [
        %{type: "option_with_correct_flag",value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag",value: "Option 2", correct?: false},
      ]},
      %{type: "multiple_choice_question", prompt: "What is the answer to screening question 2?", options: [
        %{type: "option_with_correct_flag",value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag",value: "Option 2", correct?: false},
      ]}
    ],
    demographic_questions: [
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ],
    context_questions: [
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]
  }

  setup do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, %{researcher_id: researcher_id} = command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)
    {:ok, user} = SoonReady.IdentityAndAccessManagement.Resources.User.sign_in_with_password(params.username, params.password)

    %{user: user}
  end

  test "GIVEN: An ODI survey was created, THEN: The survey is active", %{user: user} do
    # {:ok, %{project_id: project_id}} = SoonReady.OutcomeDrivenInnovation.create_survey(@survey_params)


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

    {:ok, %{project_id: project_id} = _command} = SoonReady.OutcomeDrivenInnovation.create_project(%{brand_name: "A Big Brand"})
    {:ok, _command} = SoonReady.OutcomeDrivenInnovation.define_market(%{project_id: project_id, market: %{job_executor: "Persons", job_to_be_done: "Do what persons do"}})
    {:ok, _command} = SoonReady.OutcomeDrivenInnovation.define_needs(%{
      project_id: project_id,
      job_steps: [
        %{name: "Job Step 1", desired_outcomes: [
          "Minimize the time it takes to do A",
          "Minimize the likelihood that B occurs"
        ]},
        %{name: "Job Step 2", desired_outcomes: [
          "Minimize the time it takes to do C",
          "Minimize the likelihood that D occurs"
        ]},
      ]
    })
    {:ok, %{survey_id: survey_id} = _command} = SoonReady.OutcomeDrivenInnovation.create_survey(%{
      project_id: project_id,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
      raw_screening_questions: screening_questions,
      raw_demographic_questions: demographic_questions,
      raw_context_questions: context_questions,
    })


    assert_receive_event(Application, SurveyCreationSucceededV1,
      fn event -> event.project_id == project_id end,
      fn event ->
        {:ok, survey} = Survey.get_active(event.survey_id)
        assert survey.id == event.survey_id
      end
    )
  end
end
