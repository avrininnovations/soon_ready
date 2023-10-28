defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.Validations.EmailIsUnique
  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined

  attributes do
    uuid_primary_key :id
    attribute :email, EmailAddress, allow_nil?: false
  end

  validations do
    validate {EmailIsUnique, email_field: :email}
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end

  def execute(%{__struct__: __MODULE__, id: id, email: email} = command, aggregate_state) do
    case SoonReady.Vault.encrypt(%{person_id: id, plain_text: email}, :onboarding) do
      {:ok, email_hash} ->
        WaitlistJoined.create!(%{id: id, email_hash: email_hash})
      :error ->
        {:error, :email_hashing_failed}
    end
  end
end
