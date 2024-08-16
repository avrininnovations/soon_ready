# defmodule SoonReady.SurveyManagementTest do
#   use SoonReady.DataCase

#   import Commanded.Assertions.EventAssertions

#   alias SoonReady.Application
#   alias SoonReady.SurveyManagement.V1.DomainEvents.{SurveyCreated, SurveyPublished, SurveyResponseSubmitted}

#   @old_survey_details %{
#     brand: "A Big Brand",
#     market: %{
#       job_executor: "Persons",
#       job_to_be_done: "Do what persons do"
#     },
#     job_steps: [
#       %{name: "Job Step 1", desired_outcomes: [
#         "Minimize the time it takes to do A",
#         "Minimize the likelihood that B occurs"
#       ]},
#       %{name: "Job Step 2", desired_outcomes: [
#         "Minimize the time it takes to do C",
#         "Minimize the likelihood that D occurs"
#       ]},
#     ],
#     screening_questions: [
#       %{prompt: "What is the answer to screening question 1?", options: [
#         %{value: "Option 1", is_correct: true},
#         %{value: "Option 2", is_correct: false},
#       ]},
#       %{prompt: "What is the answer to screening question 2?", options: [
#         %{value: "Option 1", is_correct: true},
#         %{value: "Option 2", is_correct: false},
#       ]}
#     ],
#     demographic_questions: [
#       %{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
#       %{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
#     ],
#     context_questions: [
#       %{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
#       %{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
#     ]
#   }

#   @old_survey_response_details %{
#     participant: %{
#       nickname: "Participant 1",
#       email: "demo@example.com",
#       phone_number: "555-555-5555"
#     },
#     screening_responses: [
#       %{prompt: "What is the answer to screening question 1?", response: "Option 1"},
#       %{prompt: "What is the answer to screening question 2?", response: "Option 1"}
#     ],
#     demographic_responses: [
#       %{prompt: "What is the answer to demographic question 1?", response: "Option 1"},
#       %{prompt: "What is the answer to demographic question 2?", response: "Option 1"}
#     ],
#     context_responses: [
#       %{prompt: "What is the answer to context question 1?", response: "Option 1"},
#       %{prompt: "What is the answer to context question 2?", response: "Option 1"}
#     ],
#     comparison_responses: [
#       %{prompt: "What products, services or platforms have you used to do what persons do?", response: "Product 1, Service 2, Platform 3"},
#       %{prompt: "What additional things do you usually use/require when you're using any of the above?", response: "Thing 1, Thing 2"},
#       %{prompt: "In total, how much would you estimate that you spend annually to do what persons do?", response: "1000"},
#       %{prompt: "Would you be willing to pay more for a better solution?", response: "Yes"},
#       %{prompt: "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", response: "1000"},
#     ],
#     desired_outcome_ratings: [
#       %{name: "Job Step 1", desired_outcomes: [
#         %{name: "Minimize the time it takes to do A", importance: "Very Important", satisfaction: "Very Satisfied"},
#         %{name: "Minimize the likelihood that B occurs", importance: "Somewhat Important", satisfaction: "Satisfied"},
#       ]},
#       %{name: "Job Step 2", desired_outcomes: [
#         %{name: "Minimize the time it takes to do C", importance: "Not At All Important", satisfaction: "Extremely Satisfied"},
#         %{name: "Minimize the likelihood that D occurs", importance: "Important", satisfaction: "Somewhat Satisfied"},
#       ]},
#     ]
#   }

#   setup do
#     params = %{
#       first_name: "John",
#       last_name: "Doe",
#       username: "john.doe",
#       password: "outatime1985",
#       password_confirmation: "outatime1985",
#     }
#     {:ok, %{researcher_id: researcher_id} = command} = SoonReadyInterface.Admin.register_researcher(params)
#     {:ok, user} = SoonReady.IdentityAndAccessManagement.Resources.User.sign_in_with_password(params.username, params.password)

#     %{user: user}
#   end

#   defp get_question(survey, page_index, question_index) do
#     survey.pages
#     |> Enum.at(page_index)
#     |> then(fn %{questions: questions} -> questions end)
#     |> Enum.at(question_index)
#     |> then(fn %{value: value} -> value end)
#   end

#   describe "Test Each Question Type" do
#     test "GIVEN: A survey with a short answer question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id,
#         pages: [
#           %{
#             id: page_id,
#             title: "Page Title",
#             questions: [
#               %{type: "short_answer_question", prompt: "The short answer prompt"},
#             ]
#           }
#         ]
#       }

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       short_answer_question = get_question(survey, 0, 0)

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{question_id: short_answer_question.id, type: "short_answer_question_response", response: "The short answer"},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )

#     end

#     test "GIVEN: A survey with a paragraph question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
#         %{
#           id: page_id,
#           title: "Page Title",
#           questions: [
#             %{type: "paragraph_question", prompt: "The paragraph prompt"},
#           ]
#         }
#       ]}

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       paragraph_question = get_question(survey, 0, 0)

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{question_id: paragraph_question.id, type: "paragraph_question_response", response: "The paragraph answer"},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )

#     end

#     test "GIVEN: A survey with a multiple choice question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
#         %{
#           id: page_id,
#           title: "Page Title",
#           questions: [
#             %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
#           ]
#         }
#       ]}

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       multiple_choice_question = get_question(survey, 0, 0)

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{question_id: multiple_choice_question.id, type: "multiple_choice_question_response", response: "Option 1"},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )

#     end

#     test "GIVEN: A survey with a checkbox question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
#         %{
#           id: page_id,
#           title: "Page Title",
#           questions: [
#             %{type: "checkbox_question", prompt: "The prompt", options: ["Option 1", "Option 2"], correct_answer_criteria: "#{:not_applicable}"},
#           ]
#         }
#       ]}

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       checkbox_question = get_question(survey, 0, 0)

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{question_id: checkbox_question.id, type: "checkbox_question_response", responses: ["Option 1", "Option 2"]},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )
#     end

#     test "GIVEN: A survey with a short answer question group has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
#         %{
#           id: page_id,
#           title: "Page Title",
#           questions: [
#             %{
#               type: "short_answer_question_group", group_prompt: "Group Prompt", questions: [
#                 %{prompt: "The prompt 1"},
#                 %{prompt: "The prompt 2"},
#               ],
#               # TODO: Nothing really tests this
#               add_button_label: "Add Question"
#             },
#           ]
#         }
#       ]}

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       %{questions: [short_answer_question_1, short_answer_question_2]} = short_answer_question_group = get_question(survey, 0, 0)

#       batch_1_response_id = Ash.UUID.generate()
#       batch_2_response_id = Ash.UUID.generate()

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{group_id: short_answer_question_group.id, type: "short_answer_question_group_responses", responses: [
#             %{batch_id: batch_1_response_id, question_id: short_answer_question_1.id, response: "The short answer 1"},
#             %{batch_id: batch_1_response_id, question_id: short_answer_question_2.id, response: "The short answer 2"},
#             %{batch_id: batch_2_response_id, question_id: short_answer_question_1.id, response: "The short answer 1"},
#             %{batch_id: batch_2_response_id, question_id: short_answer_question_2.id, response: "The short answer 2"},
#           ]},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )

#     end

#     test "GIVEN: A survey with a multiple choice question group has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#       page_id = Ash.UUID.generate()
#       survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
#         %{
#           id: page_id,
#           title: "Page Title",
#           questions: [
#             %{type: "multiple_choice_question_group", title: "Question Group 1",
#               prompts: ["Statement 1", "Statement 2"], questions: [
#               %{prompt: "The prompt", options: ["Option 1", "Option 2"]},
#               %{prompt: "The prompt", options: ["Option 1", "Option 2"]},
#             ]},
#           ]
#         }
#       ]}

#       {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#       {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#       %{prompts: [prompt_1, prompt_2], questions: [question_1, question_2]} = multiple_choice_question_group = get_question(survey, 0, 0)

#       survey_response = %{
#         survey_id: survey_id,
#         responses: [
#           %{group_id: multiple_choice_question_group.id, type: "multiple_choice_question_group_responses", responses: [
#             %{prompt_id: prompt_1.id, question_id: question_1.id, response: "Option 1"},
#             %{prompt_id: prompt_1.id, question_id: question_2.id, response: "Option 1"},
#             %{prompt_id: prompt_2.id, question_id: question_1.id, response: "Option 1"},
#             %{prompt_id: prompt_2.id, question_id: question_2.id, response: "Option 1"},
#           ]},
#         ]
#       }
#       {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#       assert_receive_event(Application, SurveyResponseSubmitted,
#         fn event -> event.response_id == response_id end,
#         fn event ->
#           assert event.survey_id == survey_id
#           assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#         end
#       )

#     end
#   end

#   test "GIVEN: A survey with three pages has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
#     page_1_id = Ash.UUID.generate()
#     page_2_id = Ash.UUID.generate()
#     page_3_id = Ash.UUID.generate()
#     final_page_id = Ash.UUID.generate()

#     survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_1_id, pages: [
#       %{
#         id: page_1_id,
#         title: "Page 1 Title",
#         transitions: [%{condition: :always, destination_page_id: page_2_id}],
#         questions: [
#           %{type: "short_answer_question", prompt: "The short answer prompt"},
#         ]
#       },
#       %{
#         id: page_2_id,
#         title: "Page 2 Title",
#         transitions: [%{condition: :always, destination_page_id: page_3_id}],
#         questions: [
#           %{type: "short_answer_question", prompt: "The short answer prompt"},
#         ]
#       },
#       %{
#         id: page_3_id,
#         title: "Page 3 Title",
#         transitions: [%{condition: :always, destination_page_id: final_page_id, submit_response?: true}],
#         questions: [
#           %{type: "short_answer_question", prompt: "The short answer prompt"},
#         ]
#       },
#       %{
#         id: final_page_id,
#         title: "Final Page Title",
#       },
#     ]}

#     {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
#     {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

#     short_answer_question = get_question(survey, 0, 0)

#     survey_response = %{
#       survey_id: survey_id,
#       responses: [
#         %{question_id: short_answer_question.id, type: "short_answer_question_response", response: "The short answer"},
#       ]
#     }
#     {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


#     assert_receive_event(Application, SurveyResponseSubmitted,
#       fn event -> event.response_id == response_id end,
#       fn event ->
#         assert event.survey_id == survey_id
#         assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
#       end
#     )

#   end

#   # TODO: Test trigger
# end
