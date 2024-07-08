defmodule SoonReady.IdentityAndAccessManagement.DomainEvents.ResearcherRegistrationSucceededV1 do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :researcher_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :user_id, :uuid, allow_nil?: false, public?: true
  end

  actions do
    default_accept [:researcher_id, :user_id]
    defaults [:create, :read]
  end

  code_interface do
    define :create
  end
end
