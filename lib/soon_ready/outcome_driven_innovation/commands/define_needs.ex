defmodule SoonReady.OutcomeDrivenInnovation.Commands.DefineNeeds do
  use Ash.Resource,
    data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.JobStep

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :job_steps, {:array, JobStep}
  end

  actions do
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
    define_for SoonReady.OutcomeDrivenInnovation
    define :dispatch
    define :create
  end
end
