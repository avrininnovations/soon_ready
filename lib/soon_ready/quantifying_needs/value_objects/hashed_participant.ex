defmodule SoonReady.QuantifyingNeeds.ValueObjects.HashedParticipant do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Should value objects have constraints and allow nils?
  # The answer in this case is a no
  attributes do
    attribute :nickname_hash, :string, allow_nil?: false
    attribute :email_hash, :string, allow_nil?: false
    attribute :phone_number_hash, :string, allow_nil?: false
  end

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :create
  end
end
