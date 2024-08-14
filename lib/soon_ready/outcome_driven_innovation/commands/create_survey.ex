defmodule SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }
  alias SoonReady.SurveyManagement.DomainConcepts.Question

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :survey_id, :uuid, allow_nil?: false, default: &Ash.UUID.generate/0
    attribute :screening_questions, {:array, Question}
    attribute :demographic_questions, {:array, Question}
    attribute :context_questions, {:array, Question}

    # TODO: Change or eliminate this
    attribute :raw_screening_questions, {:array, :map}
    attribute :raw_demographic_questions, {:array, :map}
    attribute :raw_context_questions, {:array, :map}
  end

  actions do
    default_accept [
      :project_id,
      :survey_id,
      :screening_questions,
      :demographic_questions,
      :context_questions,

      :raw_screening_questions,
      :raw_demographic_questions,
      :raw_context_questions,
    ]
    defaults [:create, :read]

    create :dispatch do
      argument :screening_questions, {:array, :map}
      argument :demographic_questions, {:array, :map}
      argument :context_questions, {:array, :map}

      change fn changeset, _context ->
        screening_questions = Ash.Changeset.get_argument(changeset, :screening_questions)
        demographic_questions = Ash.Changeset.get_argument(changeset, :demographic_questions)
        context_questions = Ash.Changeset.get_argument(changeset, :context_questions)

        changeset
        |> Ash.Changeset.change_attribute(:screening_questions, screening_questions)
        |> Ash.Changeset.change_attribute(:raw_screening_questions, screening_questions)
        |> Ash.Changeset.change_attribute(:demographic_questions, demographic_questions)
        |> Ash.Changeset.change_attribute(:raw_demographic_questions, demographic_questions)
        |> Ash.Changeset.change_attribute(:context_questions, context_questions)
        |> Ash.Changeset.change_attribute(:raw_context_questions, context_questions)
      end

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
end
