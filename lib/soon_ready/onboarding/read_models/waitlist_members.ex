defmodule SoonReady.Onboarding.ReadModels.WaitlistMembers do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: :strong

  alias __MODULE__
  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email, EmailAddress
  end

  actions do
    defaults [:read]

    create :add do
      primary? true
    end

    read :get_by_email do
      get_by [:email]
    end
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :add
    define :get_by_email
  end

  def handle(%WaitlistJoined{id: id, email: email}, _metadata) do
    with {:ok, _waitlist_member} <- WaitlistMembers.add(%{id: id, email: email}) do
      :ok
    end
  end
end
