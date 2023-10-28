defmodule SoonReady.Onboarding.DomainEvents.WaitlistJoined do
  use Ash.Resource, data_layer: :embedded,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email, EmailAddress, allow_nil?: false
    attribute :event_version, :integer, default: 1
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end
end
