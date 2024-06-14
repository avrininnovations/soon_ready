# defmodule SoonReady.OutcomeDrivenInnovation.Events.NeedsDefinedV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.JobStep

#   attributes do
#     attribute :project_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :job_steps, {:array, JobStep}
#   end

#   actions do
#     create :new
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :new
#   end
# end
