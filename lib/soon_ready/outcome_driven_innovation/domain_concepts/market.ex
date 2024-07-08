defmodule SoonReady.OutcomeDrivenInnovation.DomainConcepts.Market do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :job_executor, :string, allow_nil?: false, public?: true
    attribute :job_to_be_done, :string, allow_nil?: false, public?: true
  end
end
