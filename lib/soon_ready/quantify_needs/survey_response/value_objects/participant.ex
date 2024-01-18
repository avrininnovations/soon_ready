defmodule SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.Participant do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Should value objects have constraints and allow nils?
  attributes do
    attribute :nickname, :string, allow_nil?: false
    # TODO: Create custom types for email and phone_number
    attribute :email, :string, allow_nil?: false
    attribute :phone_number, :string, allow_nil?: false
  end
end
