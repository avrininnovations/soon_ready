defmodule SoonReady.Onboarding.DomainEvents.WaitlistJoined do
  use Ash.Resource, data_layer: :embedded,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email_hash, :string
    attribute :event_version, :integer, default: 1
  end

  defp hash(plain_text, for: person_id) do
    with :error <- SoonReady.Vault.encrypt(%{person_id: person_id, plain_text: plain_text}, :onboarding) do
      {:error, "encryption_failed"}
    end
  end


  actions do
    create :create do
      argument :email, EmailAddress, allow_nil?: false

      change fn changeset, _context ->
        Ash.Changeset.before_action(changeset, fn changeset ->
          person_id = Ash.Changeset.get_attribute(changeset, :id)
          email = Ash.Changeset.get_argument(changeset, :email)

          with {:ok, _encryption_details} <- EncryptionDetails.generate(%{person_id: person_id}),
                {:ok, email_hash} <- hash(email, for: person_id)
          do
            Ash.Changeset.change_attribute(changeset, :email_hash, email_hash)
          else
            {:error, error} ->
              Ash.Changeset.add_error(changeset, error)
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.Onboarding.Setup.Api
    define :create
  end
end
