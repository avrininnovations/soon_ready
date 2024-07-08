defmodule SoonReady.Onboarding.Commands.JoinWaitlist do
  use Ash.Resource, domain: SoonReady.Onboarding.Setup.Domain

  alias __MODULE__.Validations.EmailIsUnique
  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined
  alias SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

  attributes do
    uuid_primary_key :person_id
    attribute :email, EmailAddress, allow_nil?: false, public?: true
  end

  validations do
    validate {EmailIsUnique, email_field: :email}
  end

  actions do
    default_accept [:email]
    defaults [:create, :read]
  end

  code_interface do
    define :create
  end

  defp encrypt(plain_text, for: person_id) do
    with :error <- SoonReady.Vault.encrypt(%{person_id: person_id, plain_text: plain_text}, :onboarding) do
      {:error, :encryption_failed}
    end
  end

  def execute(%{__struct__: __MODULE__, person_id: person_id, email: email} = _command, _aggregate_state) do
    with {:ok, encryption_details} <- EncryptionDetails.generate(%{person_id: person_id}) do
      case encrypt(email, for: person_id) do
        {:ok, email_hash} ->
          WaitlistJoined.create(%{person_id: person_id, email_hash: email_hash})
        {:error, error} ->
          EncryptionDetails.destroy!(encryption_details)
          {:error, error}
      end
    end
  end
end
