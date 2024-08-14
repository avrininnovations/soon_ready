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
  end

  actions do
    default_accept [
      :project_id,
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
end
