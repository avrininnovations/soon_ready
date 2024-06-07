defmodule SoonReady.OutcomeDrivenInnovation.ResearchProject do
  use Ash.Resource
  use Commanded.Commands.Router
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.OutcomeDrivenInnovation.Commands.{CreateSurvey, MarkSurveyCreationAsSuccessful}
  alias SoonReady.OutcomeDrivenInnovation.Events.{SurveyCreationRequestedV1, SurveyCreationSucceededV1}

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :project_id
  dispatch MarkSurveyCreationAsSuccessful, to: __MODULE__, identity: :project_id

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreationRequestedV1.new(%{
      project_id: command.project_id,
      survey_id: command.survey_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def execute(_aggregate_state, %MarkSurveyCreationAsSuccessful{project_id: project_id, survey_id: survey_id} = command) do
    SurveyCreationSucceededV1.new(%{project_id: project_id, survey_id: survey_id})
  end

  def handle(%SurveyCreationRequestedV1{} = event, _metadata) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    } = event


    landing_page_id = Ecto.UUID.generate()
    screening_page_id = Ecto.UUID.generate()
    contact_details_page_id = Ecto.UUID.generate()
    demographics_page_id = Ecto.UUID.generate()
    context_page_id = Ecto.UUID.generate()
    comparison_page_id = Ecto.UUID.generate()
    desired_outcome_rating_page_id = Ecto.UUID.generate()
    thank_you_page_id = Ecto.UUID.generate()

    screening_questions = Enum.map(screening_questions, fn question -> Map.put(question, :id, Ash.UUID.generate()) end)

    survey = %{
      survey_id: survey_id,
      trigger: %{event_name: SurveyCreationRequestedV1, event_id: project_id},
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
          questions: Enum.map(screening_questions, fn %{id: question_id, prompt: prompt, options: options} = _screening_question ->
            options = Enum.map(options, fn %{value: value, is_correct: is_correct} = _option -> %{type: "option_with_correct_flag", value: value, correct?: is_correct} end)
            %{type: "multiple_choice_question", id: question_id, prompt: prompt, options: options}
          end),
          transitions: [
            %{destination_page_id: contact_details_page_id, condition: %{type: "all_true", conditions:
              Enum.map(screening_questions, fn %{id: question_id, options: options} = _screening_question ->
                correct_options = Enum.filter(options, fn option -> option.is_correct end)
                question_conditions = Enum.map(correct_options, fn %{value: value} = _option -> %{type: "response_equals", question_id: question_id, value: value} end)
                %{type: "any_true", conditions: question_conditions}
              end)
            }},
            %{destination_page_id: thank_you_page_id, submit_response?: true, condition: :always},
          ],
          actions: %{correct_response_action: %{type: "change_page", destination_page_id: contact_details_page_id}, incorrect_response_action: :submit_form},
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
          transitions: [%{condition: :always, destination_page_id: context_page_id}],
          questions: Enum.map(demographic_questions, fn %{prompt: prompt, options: options} = _demographic_question ->
            %{type: "multiple_choice_question", prompt: prompt, options: options}
          end)
        },
        %{
          id: context_page_id,
          transitions: [%{condition: :always, destination_page_id: comparison_page_id}],
          questions: Enum.map(context_questions, fn %{prompt: prompt, options: options} = _context_question ->
            %{type: "multiple_choice_question", prompt: prompt, options: options}
          end)
        },
        %{
          id: comparison_page_id,
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
          transitions: [%{destination_page_id: thank_you_page_id, submit_response?: true, condition: :always}],
          questions: Enum.map(job_steps, fn job_step ->
            %{type: "multiple_choice_question_group",
              # TODO: Wrap in "Step #{index}: #{job_step.name}"
              title: job_step.name,
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

    {:ok, _command} = MarkSurveyCreationAsSuccessful.dispatch(%{project_id: project_id, survey_id: survey_id})
    :ok
  end

  def apply(state, _event) do
    state
  end
end
