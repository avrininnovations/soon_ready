defmodule SoonReady.OutcomeDrivenInnovation.V1.Events.NeedsDefined do
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
  end

  code_interface do
    define :new
  end
end
