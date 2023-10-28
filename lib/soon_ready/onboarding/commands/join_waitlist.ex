defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.Validations.EmailIsUnique
  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined
  alias SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

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

  defp encrypt(plain_text, for: person_id) do
    with :error <- SoonReady.Vault.encrypt(%{person_id: person_id, plain_text: plain_text}, :onboarding) do
      {:error, :encryption_failed}
    end
  end

  def execute(%{__struct__: __MODULE__, id: id, email: email} = command, aggregate_state) do
    # TODO: Put in transaction
    with {:ok, _encryption_details} <- EncryptionDetails.generate(%{person_id: id}),
          {:ok, email_hash} <- encrypt(email, for: id)
    do
      WaitlistJoined.create!(%{id: id, email_hash: email_hash})
    end
  end
end
