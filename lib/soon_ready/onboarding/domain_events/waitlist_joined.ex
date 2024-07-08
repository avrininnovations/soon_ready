# TODO: Add version to name
defmodule SoonReady.Onboarding.DomainEvents.WaitlistJoined do
  use Ash.Resource,
    domain: SoonReady.Onboarding.Setup.Domain,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :person_id, :uuid, allow_nil?: false, public?: true, primary_key?: true
    attribute :email_hash, :string, allow_nil?: false, public?: true
    attribute :event_version, :integer, default: 1, public?: true
  end

  actions do
    default_accept [
      :person_id,
      :email_hash,
    ]
    defaults [:create]
  end

  code_interface do
    define :create
  end
end
