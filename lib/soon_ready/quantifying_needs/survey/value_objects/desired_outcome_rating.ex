defmodule SoonReady.QuantifyingNeeds.Survey.ValueObjects.DesiredOutcomeRating do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Should value objects have constraints and allow nils?
  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :importance, :string, allow_nil?: false
    attribute :satisfaction, :string, allow_nil?: false
  end
end
