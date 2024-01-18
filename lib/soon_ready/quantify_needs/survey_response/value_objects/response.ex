defmodule SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.Response do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Should value objects have constraints and allow nils?
  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :response, :string, allow_nil?: false
  end
end
