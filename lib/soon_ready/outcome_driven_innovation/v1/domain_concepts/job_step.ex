defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.JobStep do
  # TODO: GroupQuestion
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.{JobStatement, OutcomeStatement}

  attributes do
    attribute :name, JobStatement, allow_nil?: false, public?: true
    attribute :desired_outcomes, {:array, OutcomeStatement}, allow_nil?: false, public?: true, constraints: [min_length: 1]
  end
end
