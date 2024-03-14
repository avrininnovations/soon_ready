defmodule SoonReady.QuantifyingNeeds.SurveyResponse.ValueObjects.JobStepRating do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.SurveyResponse.ValueObjects.DesiredOutcomeRating

  # TODO: Should value objects have constraints and allow nils?
  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeRating}, allow_nil?: false, constraints: [min_length: 1]
  end
end
