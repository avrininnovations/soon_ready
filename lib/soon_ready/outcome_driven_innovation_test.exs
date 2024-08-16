defmodule SoonReady.OutcomeDrivenInnovationTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainEvents
  alias SoonReady.SurveyManagement.IntegrationEvents

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.{
    ProjectCreated,
    MarketDefined,
    NeedsDefined,
  }

  alias SoonReady.SurveyManagement.DomainEvents.{SurveyCreatedV1, SurveyPublishedV1}


  @survey_details %{
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

  describe "Survey Management" do
    # TODO: Break into test for each command
    # TODO: Fix :aggregate_execution_timeout
    test "WHEN: A researcher tries to create a survey, THEN: A survey is created", %{user: user} do
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

      # TODO: Improve inner assertions
      assert_receive_event(Application, ProjectCreated,
        fn event -> event.project_id == project_id end,
        fn _event -> :ok end
      )

      assert_receive_event(Application, MarketDefined,
        fn event -> event.project_id == project_id end,
        fn _event -> :ok end
      )

      assert_receive_event(Application, NeedsDefined,
        fn event -> event.project_id == project_id end,
        fn _event -> :ok end
      )

      assert_receive_event(Application, SurveyCreatedV1,
        fn event -> event.survey_id == survey_id end,
        fn _event -> :ok end
      )

      assert_receive_event(Application, SurveyPublishedV1,
        fn event -> event.survey_id == survey_id end,
        fn _event -> :ok end
      )
    end
  end
end
