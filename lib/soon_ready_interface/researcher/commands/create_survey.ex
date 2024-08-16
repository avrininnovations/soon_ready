defmodule SoonReadyInterface.Researcher.Commands.CreateSurvey do
  use Ash.Resource, domain: SoonReadyInterface.Researcher

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.{
    Market,
    JobStep,
  }
  alias SoonReady.SurveyManagement.DomainConcepts.{
    Question,
    Survey,
    SurveyPage,
    Trigger,
    MultipleChoiceQuestion,
    OptionWithCorrectFlag,
  }

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :survey_id, :uuid, allow_nil?: false

    attribute :brand_name, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, Question}
    attribute :demographic_questions, {:array, Question}
    attribute :context_questions, {:array, Question}

    attribute :survey, Survey, allow_nil?: false
    attribute :trigger, Trigger, allow_nil?: false

    attribute :pages_dumped_data, {:array, :map}, allow_nil?: false
  end

  changes do
    change fn changeset, _context ->
      survey_id = Ash.Changeset.get_attribute(changeset, :survey_id) || Ash.UUID.generate()
      project_id = Ash.Changeset.get_attribute(changeset, :project_id) || Ash.UUID.generate()

      changeset
      |> Ash.Changeset.change_attribute(:survey_id, survey_id)
      |> Ash.Changeset.change_attribute(:project_id, project_id)
    end

    change fn changeset, _context ->
      attrs = %{
        project_id: Ash.Changeset.get_attribute(changeset, :project_id),
        survey_id: Ash.Changeset.get_attribute(changeset, :survey_id),
        market: Ash.Changeset.get_attribute(changeset, :market),
        job_steps: Ash.Changeset.get_attribute(changeset, :job_steps),
        screening_questions: Ash.Changeset.get_attribute(changeset, :screening_questions),
        demographic_questions: Ash.Changeset.get_attribute(changeset, :demographic_questions),
        context_questions: Ash.Changeset.get_attribute(changeset, :context_questions),
      }

      Ash.Changeset.change_attribute(changeset, :survey, create_survey(attrs))
    end

    change fn changeset, _context ->
      project_id = Ash.Changeset.get_attribute(changeset, :project_id)
      Ash.Changeset.change_attribute(changeset, :trigger, %{name: __MODULE__, id: project_id})
    end

    change fn changeset, _context ->
      {:ok, record} = Ash.Changeset.apply_attributes(changeset, force?: true)

      pages_attribute = Ash.Resource.Info.attribute(record.survey, :pages)
      {:ok, pages_dumped_data} = Ash.Type.dump_to_embedded(pages_attribute.type, record.survey.pages, pages_attribute.constraints)

      Ash.Changeset.change_attribute(changeset, :pages_dumped_data, pages_dumped_data)
    end
  end

  actions do
    default_accept [
      :brand_name,
      :market,
      :job_steps,
      :survey_id,
      :screening_questions,
      :demographic_questions,
      :context_questions,
    ]
    defaults [:create, :read]

    create :dispatch do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define :dispatch
    define :create
  end

  def create_survey(attributes) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
    } = attributes

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

    survey_params = %{
      survey_id: survey_id,
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
              Enum.map(screening_questions, fn %Ash.Union{value: %MultipleChoiceQuestion{id: question_id, options: options}} = _screening_question ->
                correct_options = Enum.filter(options, fn %Ash.Union{value: %OptionWithCorrectFlag{correct?: correct?}} -> correct? end)
                question_conditions = Enum.map(correct_options, fn %Ash.Union{value: %OptionWithCorrectFlag{value: value}} = _option -> %{type: "response_equals", question_id: question_id, value: value} end)
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
  end
end
