defmodule SoonReady.SurveyManagementTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.Events.{SurveyCreatedV1, SurveyPublishedV1, SurveyResponseSubmittedV1}

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
      %{type: "short_answer_question", prompt: "The prompt"},
      %{type: "paragraph_question", prompt: "The prompt"},
      %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}]},
      # TODO: Test default :correct_answer_criteria
      # TODO: Avoid string wrapping
      %{type: "checkbox_question", prompt: "The prompt", options: ["Option 1", "Option 2"], correct_answer_criteria: "#{:not_applicable}"},
      %{type: "checkbox_question", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}], correct_answer_criteria: "#{:any_correct_option}"},
      %{type: "checkbox_question", prompt: "The prompt", options: [%{type: "option_with_correct_flag", value: "Option 1", correct?: true}, %{type: "option_with_correct_flag", value: "Option 2", correct?: false}], correct_answer_criteria: "#{:all_correct_options}"},


      %{type: "short_answer_question_group", prompt: "Multiple Choice Question Group", questions: [
        %{type: "short_answer_question", prompt: "The prompt 1"},
        %{type: "short_answer_question", prompt: "The prompt 2"},
      ]},
      %{type: "multiple_choice_question_group", prompt: "Multiple Choice Question Group",
        statements: ["Statement 1", "Statement 2"], questions: [
        %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
        %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
      ]},
    ]}
  ]}

  @survey_response_details %{

  }

  # describe "Survey Management" do
  #   test "WHEN: A researcher tries to create a survey, THEN: A survey is created", %{user: user} do
  #     {:ok, %{survey_id: survey_id} = _aggregate} = SoonReady.SurveyManagement.create_survey(@survey_details, user)

  #     assert_receive_event(Application, SurveyCreatedV1,
  #       fn event -> event.survey_id == survey_id end,
  #       fn event ->
  #         assert SoonReady.Utils.is_equal_or_subset?(event.pages, @survey_details.pages)
  #       end
  #     )
  #   end

  #   test "GIVEN: A survey has been created, WHEN: A researcher tries to publish the survey, THEN: The survey is published", %{user: user} do
  #     {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(@survey_details, user)

  #     {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

  #     assert_receive_event(Application, SurveyPublishedV1,
  #       fn event -> event.survey_id == survey_id end,
  #       fn _event ->:ok end
  #     )
  #   end
  # end

  # describe "Survey Participation" do
  #   test "GIVEN: A survey has been published, WHEN: A participant tries to submit a survey response, THEN: A survey response is submitted", %{user: user} do
  #     {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(@survey_details, user)
  #     {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

  #     response = Map.put(@survey_response_details, :survey_id, survey_id)
  #     {:ok, %{response_id: response_id} = _aggregate} = SoonReady.SurveyManagement.submit_response(response)


  #     assert_receive_event(Application, SurveyResponseSubmittedV1,
  #       fn event -> event.response_id == response_id end,
  #       fn event ->
  #         event =
  #           event
  #           |> Map.from_struct()
  #           |> SurveyResponseSubmittedV1.decrypt!()

  #         assert event.survey_id == survey_id
  #         # assert event.participant.nickname == @survey_response_details.participant.nickname
  #         # assert event.participant.email == @survey_response_details.participant.email
  #         # assert event.participant.phone_number == @survey_response_details.participant.phone_number
  #         # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.screening_responses, event.screening_responses)
  #         # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.demographic_responses, event.demographic_responses)
  #         # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.context_responses, event.context_responses)
  #         # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.comparison_responses, event.comparison_responses)
  #         # assert SoonReady.Utils.is_equal_or_subset?(@survey_response_details.desired_outcome_ratings, event.desired_outcome_ratings)
  #       end
  #     )
  #   end
  # end

  defp get_question(survey, page_index, question_index) do
    survey.pages
    |> Enum.at(page_index)
    |> then(fn %{questions: questions} -> questions end)
    |> Enum.at(question_index)
    |> then(fn %{value: value} -> value end)
  end

  test "GIVEN: A survey with a short answer question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    survey = %{pages: [
      %{questions: [
        %{type: "short_answer_question", prompt: "The short answer prompt"},
      ]}
    ]}

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    short_answer_question = get_question(survey, 0, 0)

    survey_response = %{
      survey_id: survey_id,
      responses: [
        %{question_id: short_answer_question.id, type: "short_answer_question_response", response: "The short answer"},
      ]
    }
    {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    assert_receive_event(Application, SurveyResponseSubmittedV1,
      fn event -> event.response_id == response_id end,
      fn event ->
        assert event.survey_id == survey_id
        assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
      end
    )

  end

  test "GIVEN: A survey with a paragraph question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    survey = %{pages: [
      %{questions: [
        %{type: "paragraph_question", prompt: "The paragraph prompt"},
      ]}
    ]}

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    paragraph_question = get_question(survey, 0, 0)

    survey_response = %{
      survey_id: survey_id,
      responses: [
        %{question_id: paragraph_question.id, type: "paragraph_question_response", response: "The paragraph answer"},
      ]
    }
    {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    assert_receive_event(Application, SurveyResponseSubmittedV1,
      fn event -> event.response_id == response_id end,
      fn event ->
        assert event.survey_id == survey_id
        assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
      end
    )

  end

  test "GIVEN: A survey with a multiple choice question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    survey = %{pages: [
      %{questions: [
        %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
      ]}
    ]}

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    multiple_choice_question = get_question(survey, 0, 0)

    survey_response = %{
      survey_id: survey_id,
      responses: [
        %{question_id: multiple_choice_question.id, type: "multiple_choice_question_response", response: "Option 1"},
      ]
    }
    {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    assert_receive_event(Application, SurveyResponseSubmittedV1,
      fn event -> event.response_id == response_id end,
      fn event ->
        assert event.survey_id == survey_id
        assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
      end
    )

  end

  test "GIVEN: A survey with a checkbox question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    survey = %{pages: [
      %{questions: [
        %{type: "checkbox_question", prompt: "The prompt", options: ["Option 1", "Option 2"], correct_answer_criteria: "#{:not_applicable}"},
      ]}
    ]}

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    checkbox_question = get_question(survey, 0, 0)

    survey_response = %{
      survey_id: survey_id,
      responses: [
        %{question_id: checkbox_question.id, type: "checkbox_question_response", responses: ["Option 1", "Option 2"]},
      ]
    }
    {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    assert_receive_event(Application, SurveyResponseSubmittedV1,
      fn event -> event.response_id == response_id end,
      fn event ->
        assert event.survey_id == survey_id
        assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
      end
    )
  end

  test "GIVEN: A survey with a short answer question group has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    survey = %{pages: [
      %{questions: [
        %{type: "short_answer_question_group", prompt: "Multiple Choice Question Group", questions: [
          %{type: "short_answer_question", prompt: "The prompt 1"},
          %{type: "short_answer_question", prompt: "The prompt 2"},
        ]},
      ]}
    ]}

    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    %{questions: [short_answer_question_1, short_answer_question_2]} = short_answer_question_group = get_question(survey, 0, 0)

    survey_response = %{
      survey_id: survey_id,
      responses: [
        %{question_id: short_answer_question_group.id, type: "short_answer_question_group_response", response: [
          %{question_id: short_answer_question_1.id, type: "short_answer_question_response", response: "The short answer 1"},
          %{question_id: short_answer_question_2.id, type: "short_answer_question_response", response: "The short answer 2"},
        ]},
      ]
    }
    {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    assert_receive_event(Application, SurveyResponseSubmittedV1,
      fn event -> event.response_id == response_id end,
      fn event ->
        assert event.survey_id == survey_id
        assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
      end
    )

  end

  # test "GIVEN: A single-page survey expecting a question group response has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
  #   survey = %{pages: [
  #     %{questions: [
  #       %{type: "short_answer_question_group", prompt: "Multiple Choice Question Group", questions: [
  #         %{type: "short_answer_question", prompt: "The prompt 1"},
  #         %{type: "short_answer_question", prompt: "The prompt 2"},
  #       ]},
  #       # %{type: "multiple_choice_question_group", prompt: "Multiple Choice Question Group",
  #       #   statements: ["Statement 1", "Statement 2"], questions: [
  #       #   %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
  #       #   %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
  #       # ]},
  #     ]}
  #   ]}

  #   {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey, user)
  #   {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

  #   %{questions: [short_answer_question_1, short_answer_question_2]} = short_answer_question_group = get_question(survey, 0, 0)
  #   # %{} = multiple_choice_question_group = get_question(survey, 0, 1)

  #   survey_response = %{
  #     survey_id: survey_id,
  #     responses: [
  #       %{question_id: short_answer_question_group.id, type: "short_answer_question_group_response", response: [
  #         %{question_id: short_answer_question_1.id, type: "single_value_response", response: "The short answer 1"},
  #         %{question_id: short_answer_question_2.id, type: "single_value_response", response: "The short answer 2"},
  #       ]},
  #       # %{question_id: multiple_choice_question_group.id, type: "short_answer_question_group_response", response: [
  #       #   %{question_id: short_answer_question_1.id, type: "single_value_response", response: "Option 1"},
  #       #   %{question_id: short_answer_question_2.id, type: "single_value_response", response: "Option 1"},
  #       # ]},
  #     ]
  #   }
  #   {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


  #   assert_receive_event(Application, SurveyResponseSubmittedV1,
  #     fn event -> event.response_id == response_id end,
  #     fn event ->
  #       assert event.survey_id == survey_id
  #       assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
  #     end
  #   )

  # end
end
