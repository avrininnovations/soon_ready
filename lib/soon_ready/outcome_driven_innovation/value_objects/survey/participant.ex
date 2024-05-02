defmodule SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.Participant do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Should value objects have constraints and allow nils?
  attributes do
    attribute :nickname, :string, allow_nil?: false
    # TODO: Create custom types for email and phone_number
    attribute :email, :string, allow_nil?: false
    attribute :phone_number, :string, allow_nil?: false
  end

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define_for SoonReady.OutcomeDrivenInnovation.Survey
    define :create
  end
end
