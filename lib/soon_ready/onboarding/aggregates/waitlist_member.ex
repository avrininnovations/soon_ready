defmodule SoonReady.Onboarding.Aggregates.WaitlistMember do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.Commands.JoinWaitlist
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined
  alias __MODULE__

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email, EmailAddress, allow_nil?: false
  end

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end

  def execute(_aggregate_state, %JoinWaitlist{id: id, email: email} = command) do
    WaitlistJoined.create!(%{id: id, email: email})
  end

  def apply(state, %WaitlistJoined{id: id, email: email}) do
    WaitlistMember.create!(%{id: id, email: email})
  end

  def apply(state, _event) do
    state
  end
end
