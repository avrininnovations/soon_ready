defmodule SoonReadyInterface.Respondent.Commands.SubmitSurveyResponseTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.V1.DomainEvents.{SurveyCreated, SurveyPublished, SurveyResponseSubmitted}

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

  describe "Test Each Question Type" do
    test "GIVEN: A survey with a short answer question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
      page_id = Ash.UUID.generate()
      survey_id = Ash.UUID.generate()

      survey = %{survey_id: survey_id, starting_page_id: page_id,
        pages: [
          %{
            id: page_id,
            title: "Page Title",
            questions: [
              %{type: "short_answer_question", prompt: "The short answer prompt"},
            ]
          }
        ]
      }

      {:ok, [_survey_created_event, survey_published_event]} = append_events_to_stream(survey)
      short_answer_question = get_question(survey_published_event, 0, 0)

      survey_response = %{
        survey_id: survey_id,
        responses: [
          %{question_id: short_answer_question.id, type: "short_answer_question_response", response: "The short answer"},
        ]
      }
      {:ok, command} = SoonReadyInterface.Respondent.submit_response(survey_response)


      assert_receive_event(Application, SurveyResponseSubmitted,
        fn event -> event.response_id == command.response_id end,
        fn event ->
          {:ok, event} = SurveyResponseSubmitted.regenerate(event)
          assert event.survey_id == command.survey_id
          assert Jason.encode(event.responses) == Jason.encode(command.responses)
        end
      )
    end

    test "GIVEN: A survey with a paragraph question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
      page_id = Ash.UUID.generate()
      survey_id = Ash.UUID.generate()

      survey = %{survey_id: survey_id, starting_page_id: page_id,
        pages: [
          %{
            id: page_id,
            title: "Page Title",
            questions: [
              %{type: "paragraph_question", prompt: "The paragraph prompt"},
            ]
          }
        ]
      }

      {:ok, [_survey_created_event, survey_published_event]} = append_events_to_stream(survey)
      paragraph_question = get_question(survey_published_event, 0, 0)

      survey_response = %{
        survey_id: survey_id,
        responses: [
          %{question_id: paragraph_question.id, type: "paragraph_question_response", response: "The paragraph answer"},
        ]
      }
      {:ok, command} = SoonReadyInterface.Respondent.submit_response(survey_response)


      assert_receive_event(Application, SurveyResponseSubmitted,
        fn event -> event.response_id == command.response_id end,
        fn event ->
          {:ok, event} = SurveyResponseSubmitted.regenerate(event)
          assert event.survey_id == command.survey_id
          assert Jason.encode(event.responses) == Jason.encode(command.responses)
        end
      )
    end

    test "GIVEN: A survey with a multiple choice question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
      page_id = Ash.UUID.generate()
      survey_id = Ash.UUID.generate()

      survey = %{survey_id: survey_id, starting_page_id: page_id,
        pages: [
          %{
            id: page_id,
            title: "Page Title",
            questions: [
              %{type: "multiple_choice_question", prompt: "The prompt", options: ["Option 1", "Option 2"]},
            ]
          }
        ]
      }

      {:ok, [_survey_created_event, survey_published_event]} = append_events_to_stream(survey)
      multiple_choice_question = get_question(survey_published_event, 0, 0)

      survey_response = %{
        survey_id: survey_id,
        responses: [
          %{question_id: multiple_choice_question.id, type: "multiple_choice_question_response", response: "Option 1"},
        ]
      }
      {:ok, command} = SoonReadyInterface.Respondent.submit_response(survey_response)


      assert_receive_event(Application, SurveyResponseSubmitted,
        fn event -> event.response_id == command.response_id end,
        fn event ->
          {:ok, event} = SurveyResponseSubmitted.regenerate(event)
          assert event.survey_id == command.survey_id
          assert Jason.encode(event.responses) == Jason.encode(command.responses)
        end
      )
    end

    test "GIVEN: A survey with a checkbox question has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
      page_id = Ash.UUID.generate()
      survey_id = Ash.UUID.generate()

      survey = %{survey_id: survey_id, starting_page_id: page_id,
        pages: [
          %{
            id: page_id,
            title: "Page Title",
            questions: [
              %{type: "checkbox_question", prompt: "The prompt", options: ["Option 1", "Option 2"], correct_answer_criteria: "#{:not_applicable}"},
            ]
          }
        ]
      }

      {:ok, [_survey_created_event, survey_published_event]} = append_events_to_stream(survey)
      checkbox_question = get_question(survey_published_event, 0, 0)

      survey_response = %{
        survey_id: survey_id,
        responses: [
          %{question_id: checkbox_question.id, type: "checkbox_question_response", responses: ["Option 1", "Option 2"]},
        ]
      }
      {:ok, command} = SoonReadyInterface.Respondent.submit_response(survey_response)


      assert_receive_event(Application, SurveyResponseSubmitted,
        fn event -> event.response_id == command.response_id end,
        fn event ->
          {:ok, event} = SurveyResponseSubmitted.regenerate(event)
          assert event.survey_id == command.survey_id
          assert Jason.encode(event.responses) == Jason.encode(command.responses)
        end
      )
    end

    # test "GIVEN: A survey with a short answer question group has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    #   page_id = Ash.UUID.generate()
    #   survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
    #     %{
    #       id: page_id,
    #       title: "Page Title",
    #       questions: [
    #         %{
    #           type: "short_answer_question_group", group_prompt: "Group Prompt", questions: [
    #             %{prompt: "The prompt 1"},
    #             %{prompt: "The prompt 2"},
    #           ],
    #           # TODO: Nothing really tests this
    #           add_button_label: "Add Question"
    #         },
    #       ]
    #     }
    #   ]}

    #   {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
    #   {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    #   %{questions: [short_answer_question_1, short_answer_question_2]} = short_answer_question_group = get_question(survey, 0, 0)

    #   batch_1_response_id = Ash.UUID.generate()
    #   batch_2_response_id = Ash.UUID.generate()

    #   survey_response = %{
    #     survey_id: survey_id,
    #     responses: [
    #       %{group_id: short_answer_question_group.id, type: "short_answer_question_group_responses", responses: [
    #         %{batch_id: batch_1_response_id, question_id: short_answer_question_1.id, response: "The short answer 1"},
    #         %{batch_id: batch_1_response_id, question_id: short_answer_question_2.id, response: "The short answer 2"},
    #         %{batch_id: batch_2_response_id, question_id: short_answer_question_1.id, response: "The short answer 1"},
    #         %{batch_id: batch_2_response_id, question_id: short_answer_question_2.id, response: "The short answer 2"},
    #       ]},
    #     ]
    #   }
    #   {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    #   assert_receive_event(Application, SurveyResponseSubmitted,
    #     fn event -> event.response_id == response_id end,
    #     fn event ->
    #       assert event.survey_id == survey_id
    #       assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
    #     end
    #   )

    # end

    # test "GIVEN: A survey with a multiple choice question group has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
    #   page_id = Ash.UUID.generate()
    #   survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_id, pages: [
    #     %{
    #       id: page_id,
    #       title: "Page Title",
    #       questions: [
    #         %{type: "multiple_choice_question_group", title: "Question Group 1",
    #           prompts: ["Statement 1", "Statement 2"], questions: [
    #           %{prompt: "The prompt", options: ["Option 1", "Option 2"]},
    #           %{prompt: "The prompt", options: ["Option 1", "Option 2"]},
    #         ]},
    #       ]
    #     }
    #   ]}

    #   {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
    #   {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

    #   %{prompts: [prompt_1, prompt_2], questions: [question_1, question_2]} = multiple_choice_question_group = get_question(survey, 0, 0)

    #   survey_response = %{
    #     survey_id: survey_id,
    #     responses: [
    #       %{group_id: multiple_choice_question_group.id, type: "multiple_choice_question_group_responses", responses: [
    #         %{prompt_id: prompt_1.id, question_id: question_1.id, response: "Option 1"},
    #         %{prompt_id: prompt_1.id, question_id: question_2.id, response: "Option 1"},
    #         %{prompt_id: prompt_2.id, question_id: question_1.id, response: "Option 1"},
    #         %{prompt_id: prompt_2.id, question_id: question_2.id, response: "Option 1"},
    #       ]},
    #     ]
    #   }
    #   {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


    #   assert_receive_event(Application, SurveyResponseSubmitted,
    #     fn event -> event.response_id == response_id end,
    #     fn event ->
    #       assert event.survey_id == survey_id
    #       assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
    #     end
    #   )

    # end
  end

  # test "GIVEN: A survey with three pages has been published, WHEN: A participant tries to submit a response, THEN: A survey response is submitted", %{user: user} do
  #   page_1_id = Ash.UUID.generate()
  #   page_2_id = Ash.UUID.generate()
  #   page_3_id = Ash.UUID.generate()
  #   final_page_id = Ash.UUID.generate()

  #   survey = %{survey_id: Ash.UUID.generate(), starting_page_id: page_1_id, pages: [
  #     %{
  #       id: page_1_id,
  #       title: "Page 1 Title",
  #       transitions: [%{condition: :always, destination_page_id: page_2_id}],
  #       questions: [
  #         %{type: "short_answer_question", prompt: "The short answer prompt"},
  #       ]
  #     },
  #     %{
  #       id: page_2_id,
  #       title: "Page 2 Title",
  #       transitions: [%{condition: :always, destination_page_id: page_3_id}],
  #       questions: [
  #         %{type: "short_answer_question", prompt: "The short answer prompt"},
  #       ]
  #     },
  #     %{
  #       id: page_3_id,
  #       title: "Page 3 Title",
  #       transitions: [%{condition: :always, destination_page_id: final_page_id, submit_response?: true}],
  #       questions: [
  #         %{type: "short_answer_question", prompt: "The short answer prompt"},
  #       ]
  #     },
  #     %{
  #       id: final_page_id,
  #       title: "Final Page Title",
  #     },
  #   ]}

  #   {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
  #   {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})

  #   short_answer_question = get_question(survey, 0, 0)

  #   survey_response = %{
  #     survey_id: survey_id,
  #     responses: [
  #       %{question_id: short_answer_question.id, type: "short_answer_question_response", response: "The short answer"},
  #     ]
  #   }
  #   {:ok, %{response_id: response_id} = command} = SoonReady.SurveyManagement.submit_response(survey_response)


  #   assert_receive_event(Application, SurveyResponseSubmitted,
  #     fn event -> event.response_id == response_id end,
  #     fn event ->
  #       assert event.survey_id == survey_id
  #       assert SoonReady.Utils.is_equal_or_subset?(survey_response.responses, event.responses)
  #     end
  #   )

  # end

  # TODO: Test trigger


  defp get_question(survey, page_index, question_index) do
    survey.pages
    |> Enum.at(page_index)
    |> then(fn %{questions: questions} -> questions end)
    |> Enum.at(question_index)
    |> then(fn %{value: value} -> value end)
  end

  defp append_events_to_stream(%{survey_id: survey_id} = survey) do
    {:ok, survey_created_event} = SurveyCreated.new(survey)
    {:ok, survey_published_event} = SurveyPublished.new(survey)

    causation_id = Ash.UUID.generate()
    correlation_id = Ash.UUID.generate()

    event_data =
      Enum.map([survey_created_event, survey_published_event], fn event ->
        %Commanded.EventStore.EventData{
          causation_id: causation_id,
          correlation_id: correlation_id,
          event_type: Commanded.EventStore.TypeProvider.to_string(event),
          data: event,
          metadata: %{},
        }
      end)

    expected_version = 0
    :ok = Commanded.EventStore.append_to_stream(SoonReady.Application, survey_id, expected_version, event_data)

    {:ok, [survey_created_event, survey_published_event]}
  end
end
