defmodule SoonReady.SurveyManagementTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.Events.{SurveyCreatedV1, SurveyPublishedV1, SurveyResponseSubmittedV1}

  # TODO: Remove Survey prefix
  alias SoonReady.SurveyManagement.ValueObjects.Survey.{SingleSelectQuestion, MultiSelectQuestion}
  alias SoonReady.SurveyManagement.ValueObjects.OptionWithCorrectFlag

  @old_survey_details %{
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

  @old_survey_response_details %{
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

  @survey_details %{pages: [
    %{questions: [
      %{type: "single_select_option", prompt: "The prompt", options: ["Option 1", "Option 2"]},
      %{type: "single_select_option", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}]},
      # TODO: Test default :correct_answer_criteria
      # TODO: Avoid string wrapping
      %{type: "multi_select_option", prompt: "The prompt", options: ["Option 1", "Option 2"], correct_answer_criteria: "#{:not_applicable}"},
      %{type: "multi_select_option", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}], correct_answer_criteria: "#{:any_correct_option}"},
      %{type: "multi_select_option", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}], correct_answer_criteria: "#{:all_correct_options}"},
    ]}
  ]}

  @survey_response_details %{

  }

  describe "Survey Management" do
    test "WHEN: A researcher tries to create a survey, THEN: A survey is created", %{user: user} do
      {:ok, %{survey_id: survey_id} = _aggregate} = SoonReady.SurveyManagement.create_survey(@survey_details, user)

      assert_receive_event(Application, SurveyCreatedV1,
        fn event -> event.survey_id == survey_id end,
        fn event ->
          assert SoonReady.Utils.is_equal_or_subset?(event.pages, @survey_details.pages)
        end
      )
    end

    test "GIVEN: A survey has been created, WHEN: A researcher tries to publish the survey, THEN: The survey is published", %{user: user} do
      {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(@survey_details, user)

      {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

      assert_receive_event(Application, SurveyPublishedV1,
        fn event -> event.survey_id == survey_id end,
        fn _event ->:ok end
      )
    end
  end

  describe "Survey Participation" do
    test "GIVEN: A survey has been published, WHEN: A participant tries to submit a survey response, THEN: A survey response is submitted", %{user: user} do
      {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(@survey_details, user)
      {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

      response = Map.put(@survey_response_details, :survey_id, survey_id)
      {:ok, %{response_id: response_id} = _aggregate} = SoonReady.SurveyManagement.submit_response(response)


      assert_receive_event(Application, SurveyResponseSubmittedV1,
        fn event -> event.response_id == response_id end,
        fn event ->
          event =
            event
            |> Map.from_struct()
            |> SurveyResponseSubmittedV1.decrypt!()

          assert event.survey_id == survey_id
          # assert event.participant.nickname == @survey_response_details.participant.nickname
          # assert event.participant.email == @survey_response_details.participant.email
          # assert event.participant.phone_number == @survey_response_details.participant.phone_number
          # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.screening_responses, event.screening_responses)
          # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.demographic_responses, event.demographic_responses)
          # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.context_responses, event.context_responses)
          # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.comparison_responses, event.comparison_responses)
          # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.desired_outcome_ratings, event.desired_outcome_ratings)
        end
      )
    end
  end
end
