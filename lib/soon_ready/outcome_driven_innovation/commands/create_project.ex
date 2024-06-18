defmodule SoonReady.OutcomeDrivenInnovation.Commands.CreateProject do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }
  alias SoonReady.SurveyManagement.DomainConcepts.Question

  attributes do
    uuid_primary_key :project_id
    attribute :brand_name, :string
  end

  actions do
    default_accept [
      :project_id,
      :brand_name,
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
