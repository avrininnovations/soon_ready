defmodule SoonReady.QuantifyingNeeds.Survey.ValueObjects.ScreeningQuestion.Option do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :value, :string, allow_nil?: false
    attribute :is_correct, :boolean, allow_nil?: false
  end
end