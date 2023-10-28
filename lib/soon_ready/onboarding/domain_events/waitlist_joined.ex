defmodule SoonReady.Onboarding.DomainEvents.WaitlistJoined do
  use Ash.Resource, data_layer: :embedded,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email_hash, :string, allow_nil?: false
    attribute :event_version, :integer, default: 1
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end
end
