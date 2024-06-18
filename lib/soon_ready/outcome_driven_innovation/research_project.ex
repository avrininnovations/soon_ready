defmodule SoonReady.OutcomeDrivenInnovation.ResearchProject do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation
  use Commanded.Commands.Router
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.OutcomeDrivenInnovation.Commands.{
    CreateProject,
    DefineMarket,
    DefineNeeds,
    CreateSurvey,
    MarkSurveyCreationAsSuccessful,
  }
  alias SoonReady.OutcomeDrivenInnovation.Events.{
    ProjectCreatedV1,
    MarketDefinedV1,
    NeedsDefinedV1,
    SurveyCreationRequestedV1,
    SurveyCreationSucceededV1,
  }

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }

  alias SoonReady.SurveyManagement.Events.SurveyPublishedV1

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
  end

  actions do
    default_accept [
      :project_id,
      :market,
      :job_steps,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch CreateProject, to: __MODULE__, identity: :project_id
  dispatch DefineMarket, to: __MODULE__, identity: :project_id
  # dispatch DefineNeeds, to: __MODULE__, identity: :project_id
  # dispatch CreateSurvey, to: __MODULE__, identity: :project_id
  # dispatch MarkSurveyCreationAsSuccessful, to: __MODULE__, identity: :project_id

  def execute(_aggregate_state, %CreateProject{project_id: project_id, brand_name: brand_name} = _command) do
    ProjectCreatedV1.new(%{
      project_id: project_id,
      brand_name: brand_name,
    })
  end

  def execute(_aggregate_state, %DefineMarket{project_id: project_id, market: market} = _command) do
    MarketDefinedV1.new(%{
      project_id: project_id,
      market: market,
    })
  end

  # def execute(_aggregate_state, %DefineNeeds{project_id: project_id, job_steps: job_steps} = _command) do
  #   NeedsDefinedV1.new(%{
  #     project_id: project_id,
  #     job_steps: job_steps,
  #   })
  # end

  # def execute(aggregate_state, %CreateSurvey{} = command) do
  #   params = %{
  #     project_id: command.project_id,
  #     survey_id: command.survey_id,
  #     market: aggregate_state.market,
  #     job_steps: aggregate_state.job_steps,
  #     screening_questions: command.raw_screening_questions,
  #     demographic_questions: command.raw_demographic_questions,
  #     context_questions: command.raw_context_questions,
  #     trigger: %{name: CreateSurvey, id: command.project_id}
  #   }

  #   with {:ok, %{survey_id: survey_id}} <- create_and_publish_survey(params) do
  #     SurveyCreationRequestedV1.new(%{
  #       project_id: command.project_id,
  #       survey_id: survey_id,
  #     })
  #   end
  # end

  defp create_and_publish_survey(params) do
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

    questions = Enum.map(job_steps, fn job_step ->
      %{type: "multiple_choice_question_group",
        # TODO: Wrap in "Step #{index}: #{job_step.name}"
        title: job_step.name,
        prompts: job_step.desired_outcomes,
        questions: [
          %{
            type: "multiple_choice_question",
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
    |> IO.inspect()

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
          questions: questions
        },
        %{
          id: thank_you_page_id,
          title: "Thank You!",
        },
      ]
    }

    # TODO: Handle any that happens failure with its own event
    {:ok, %{survey_id: survey_id} = survey} = SoonReady.SurveyManagement.create_survey(survey)
    |> IO.inspect()
    {:ok, %{survey_id: ^survey_id}} = SoonReady.SurveyManagement.publish_survey(%{survey_id: survey_id})
  end

  # def execute(_aggregate_state, %MarkSurveyCreationAsSuccessful{project_id: project_id, survey_id: survey_id} = command) do
  #   IO.inspect("INSIDE MarkSurveyCreationAsSuccessful")
  #   SurveyCreationSucceededV1.new(%{project_id: project_id, survey_id: survey_id})
  # end

  def apply(state, %ProjectCreatedV1{project_id: project_id}) do
    __MODULE__.create!(%{project_id: project_id})
  end

  def apply(state, %MarketDefinedV1{market: market}) do
    __MODULE__.update!(state, %{market: market})
  end

  # def apply(state, %NeedsDefinedV1{job_steps: job_steps}) do
  #   __MODULE__.update!(state, %{job_steps: job_steps})
  # end

  def apply(state, _event) do
    IO.inspect("INSIDE Apply, #{inspect(_event)}")

    state
  end

  # # TODO
  # def handle(%SurveyPublishedV1{survey_id: survey_id, trigger: trigger} = event, _metadata) do
  #   case trigger do
  #     %{name: trigger_name, id: trigger_id} ->
  #       if trigger_name == "#{CreateSurvey}" do
  #         {:ok, _command} = MarkSurveyCreationAsSuccessful.dispatch(%{project_id: trigger_id, survey_id: survey_id})
  #         :ok
  #       else
  #         :ok
  #       end
  #     _ -> :ok
  #   end
  # end

  # def handle(_event, _metadata) do
  #   :ok
  # end
end
