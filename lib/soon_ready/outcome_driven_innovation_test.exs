defmodule SoonReady.OutcomeDrivenInnovationTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.Events.{SurveyCreationRequestedV1, SurveyCreationSucceededV1}
  alias SoonReady.SurveyManagement.Events.{SurveyCreatedV1, SurveyPublishedV1}


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
    {:ok, %{researcher_id: researcher_id} = command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)

    {:ok, %{user: user}} = SoonReady.IdentityAndAccessManagement.get_researcher(researcher_id)
    %{user: user}
  end

  describe "Survey Management" do
    # TODO: Break into test for each command
    test "WHEN: A researcher tries to create a survey, THEN: A survey is created", %{user: user} do
      screening_questions = [
        %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 1?", options: [
          %{type: "option_with_correct_flag",value: "Option 1", correct?: true},
          %{type: "option_with_correct_flag",value: "Option 2", correct?: false},
        ]},
        %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 2?", options: [
          %{type: "option_with_correct_flag",value: "Option 1", correct?: true},
          %{type: "option_with_correct_flag",value: "Option 2", correct?: false},
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

      assert_receive_event(Application, SurveyCreationRequestedV1,
        fn event -> event.project_id == project_id end,
        fn event ->
          assert event.survey_id == survey_id
          # # TODO: Add richer tests
          # assert SoonReady.Utils.is_equal_or_subset?(event.brand, @survey_details.brand)
          # assert SoonReady.Utils.is_equal_or_subset?(event.market, @survey_details.market)
          # assert SoonReady.Utils.is_equal_or_subset?(event.job_steps, @survey_details.job_steps)
          # assert SoonReady.Utils.is_equal_or_subset?(event.screening_questions, @survey_details.screening_questions)
          # assert SoonReady.Utils.is_equal_or_subset?(event.demographic_questions, @survey_details.demographic_questions)
          # assert SoonReady.Utils.is_equal_or_subset?(event.context_questions, @survey_details.context_questions)
        end
      )

      assert_receive_event(Application, SurveyCreatedV1,
        fn event ->
          %{trigger: trigger} = event
          expected_trigger_event_name = "#{SurveyCreationRequestedV1}"
          case trigger do
            %{event_name: ^expected_trigger_event_name, event_id: ^project_id} -> true
            _ -> false
          end
        end,
        fn survey_created_event ->
          assert_receive_event(Application, SurveyPublishedV1,
            fn event -> event.survey_id == survey_created_event.survey_id end,
            fn survey_created_event -> :ok end
          )
          assert_receive_event(Application, SurveyCreationSucceededV1,
            fn event -> event.project_id == project_id end,
            fn event ->
              assert event.survey_id == survey_created_event.survey_id
            end
          )
        end
      )
    end
  end
end
