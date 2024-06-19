defmodule SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails do
  use Ash.Resource,
    domain: SoonReady.Onboarding.Setup.Domain,
    data_layer: AshPostgres.DataLayer

  attributes do
    attribute :person_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :cloak_key, :string, allow_nil?: false
  end

  actions do
    default_accept [:person_id]
    defaults [:read, :destroy]

    create :generate do
      primary? true

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :cloak_key, 32 |> :crypto.strong_rand_bytes() |> Base.encode64())
      end
    end

    read :get do
      get_by [:person_id]
    end
  end

  code_interface do
    define :generate
    define :get
    define :read
    define :destroy
  end

  postgres do
    repo SoonReady.Repo
    table "onboarding__personally_identifiable_information__encryption_details"
  end

  def get_key(person_id) do
    with {:ok, %{__struct__: __MODULE__, cloak_key: cloak_key}} <- __MODULE__.get(%{person_id: person_id}) do
      {:ok, Base.decode64!(cloak_key)}
    end
  end
end
