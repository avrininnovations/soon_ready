defmodule SoonReady.QuantifyingNeeds.ValueObjects.JobStep do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.ValueObjects.{JobStatement, OutcomeStatement}

  attributes do
    attribute :name, JobStatement, allow_nil?: false
    attribute :desired_outcomes, {:array, OutcomeStatement}, allow_nil?: false, constraints: [min_length: 1]
  end
end
