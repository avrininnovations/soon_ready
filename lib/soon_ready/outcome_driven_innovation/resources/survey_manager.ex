defmodule SoonReady.OutcomeDrivenInnovation.Resources.SurveyManager do
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}"
    # NOTE: Translators must always be eventually consistent

  # TODO: Change to integration event
  alias SoonReady.SurveyManagement.Events.SurveyPublishedV1

  alias SoonReady.OutcomeDrivenInnovation.Commands.MarkSurveyCreationAsSuccessful

  def handle(%SurveyPublishedV1{survey_id: survey_id, trigger: trigger} = event, _metadata) do
    case trigger do
      %{name: trigger_name, id: trigger_id} ->
        if trigger_name == "#{SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey}" do
          {:ok, _command} = MarkSurveyCreationAsSuccessful.dispatch(%{project_id: trigger_id, survey_id: survey_id})
          :ok
        else
          :ok
        end
      _ -> :ok
    end
  end

  def handle(_event, _metadata) do
    :ok
  end

  def create_and_publish_survey(params) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
      trigger: trigger,
    } = params

    landing_page_id = Ecto.UUID.generate()
    screening_page_id = Ecto.UUID.generate()
    contact_details_page_id = Ecto.UUID.generate()
    demographics_page_id = Ecto.UUID.generate()
    context_page_id = Ecto.UUID.generate()
    comparison_page_id = Ecto.UUID.generate()
    desired_outcome_rating_page_id = Ecto.UUID.generate()
    thank_you_page_id = Ecto.UUID.generate()

    desired_outcome_rating_questions =
      job_steps
      |> Enum.with_index()
      |> Enum.map(fn {job_step, index} ->
        %{type: "multiple_choice_question_group",
          title: "Step #{index + 1}: #{job_step.name}",
          prompts: job_step.desired_outcomes,
          questions: [
            %{
              prompt: "When you #{String.downcase(job_step.name)}, how important is it to you to:",
              options: [
                "Not At All Important",
                "Somewhat Important",
                "Important",
                "Very Important",
                "Extremely Important"
              ]
            },
            %{
              prompt: "Given the solutions you currently have, how satisfied are you with your ability to:",
              options: [
                "Not At All Satisfied",
                "Somewhat Satisfied",
                "Satisfied",
                "Very Satisfied",
                "Extremely Satisfied"
              ]
            },
          ]
        }
      end)

    survey = %{
      survey_id: survey_id,
      trigger: trigger,
      starting_page_id: landing_page_id,
      pages: [
        %{
          id: landing_page_id,
          transitions: [%{condition: :always, destination_page_id: screening_page_id}],
          title: "Welcome to our Survey!",
          questions: [
            %{type: "short_answer_question", prompt: "Your nickname"},
          ]
        },
        %{
          id: screening_page_id,
          title: "Screening Questions",
          questions: screening_questions,
          transitions: [
            %{destination_page_id: contact_details_page_id, condition: %{type: "all_true", conditions:
              Enum.map(screening_questions, fn %{id: question_id, options: options} = _screening_question ->
                correct_options = Enum.filter(options, fn option -> option.correct? end)
                question_conditions = Enum.map(correct_options, fn %{value: value} = _option -> %{type: "response_equals", question_id: question_id, value: value} end)
                %{type: "any_true", conditions: question_conditions}
              end)
            }},
            %{destination_page_id: thank_you_page_id, submit_response?: true, condition: :always},
          ],
        },
        %{
          id: contact_details_page_id,
          transitions: [%{condition: :always, destination_page_id: demographics_page_id}],
          title: "Contact Details",
          questions: [
            %{type: "short_answer_question", prompt: "Email"},
            %{type: "short_answer_question", prompt: "Phone Number"},
          ]
        },
        %{
          id: demographics_page_id,
          title: "Demographics",
          transitions: [%{condition: :always, destination_page_id: context_page_id}],
          questions: demographic_questions
        },
        %{
          id: context_page_id,
          title: "Context",
          transitions: [%{condition: :always, destination_page_id: comparison_page_id}],
          questions: context_questions
        },
        %{
          id: comparison_page_id,
          title: "Comparison",
          transitions: [%{condition: :always, destination_page_id: desired_outcome_rating_page_id}],
          questions: [
            %{type: "paragraph_question", prompt: "What products, services or platforms have you used to #{String.downcase(market.job_to_be_done)}?"},
            %{type: "paragraph_question", prompt: "What additional things do you usually use/require when you're using any of the above?"},
            %{type: "short_answer_question", prompt: "In total, how much would you estimate that you spend annually to #{String.downcase(market.job_to_be_done)}?"},
            %{type: "multiple_choice_question", prompt: "Would you be willing to pay more for a better solution?", options: ["Yes", "No"]},
            %{type: "short_answer_question", prompt: "If yes, how much extra would you be willing to pay annually to get the job done perfectly?"},
          ]
        },
        %{
          id: desired_outcome_rating_page_id,
          title: "Desired Outcome Ratings",
          transitions: [%{destination_page_id: thank_you_page_id, submit_response?: true, condition: :always}],
          questions: desired_outcome_rating_questions
        },
        %{
          id: thank_you_page_id,
          title: "Thank You!",
        },
      ]
    }

    # TODO: Handle any that happens failure with its own event
    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})
  end
end
