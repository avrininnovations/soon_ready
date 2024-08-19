defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.NeedsDefined do
  use Ash.Resource,
    domain: SoonReady.OutcomeDrivenInnovation,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.JobStep

  attributes do
    attribute :project_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :job_steps, {:array, JobStep}, public?: true
  end

  actions do
    default_accept [
      :project_id,
      :job_steps,
    ]
    create :new

    create :regenerate do
      argument :event, :struct, constraints: [instance_of: __MODULE__], allow_nil?: false

      change fn changeset, _context ->
        event = Ash.Changeset.get_argument(changeset, :event)

        changeset
        |> Ash.Changeset.change_attribute(:project_id, event.project_id)
        |> Ash.Changeset.change_attribute(:job_steps, event.job_steps)
      end
    end
  end

  code_interface do
    define :new
    define :regenerate, args: [:event]
  end
end
