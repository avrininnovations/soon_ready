defmodule SoonReady.Onboarding.ReadModels.WaitlistMembers do
  use Ash.Resource,
    domain: SoonReady.Onboarding.Setup.Domain,
    data_layer: AshPostgres.DataLayer

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: :strong

  alias SoonReady.Onboarding.DomainConcepts.EmailAddress
  alias SoonReady.Onboarding.DomainEvents.WaitlistJoined

  attributes do
    attribute :person_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :email, EmailAddress
  end

  actions do
    default_accept [
      :person_id,
      :email,
    ]
    defaults [:read]

    create :add do
      primary? true
    end

    read :get_by_email do
      get_by [:email]
    end
  end

  code_interface do
    define :add
    define :get_by_email
  end

  postgres do
    repo SoonReady.Repo
    table "onboarding__read_models__waitlist_members"
  end

  def handle(%WaitlistJoined{person_id: person_id, email_hash: email_hash}, _metadata) do
    case SoonReady.Vault.decrypt(%{person_id: person_id, cipher_text: email_hash}) do
      {:ok, email} ->
        with {:ok, _waitlist_member} <- __MODULE__.add(%{person_id: person_id, email: email}) do
          :ok
        end
      :error ->
        {:error, :email_decryption_failed}
    end
  end
end
