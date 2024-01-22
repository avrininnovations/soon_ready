defmodule SoonReady.QuantifyingNeeds.Survey.ValueObjects.JobStep do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.Survey.DomainDataTypes.{JobStep, DesiredOutcome}

  attributes do
    attribute :name, JobStep, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcome}, allow_nil?: false, constraints: [min_length: 1]
  end
end
