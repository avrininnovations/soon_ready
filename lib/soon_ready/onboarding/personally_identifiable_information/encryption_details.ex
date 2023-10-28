defmodule SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    attribute :person_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :cloak_key, :string
  end

  actions do
    defaults [:read]

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
    define_for SoonReady.Onboarding.Setup.Api
    define :generate
    define :get
  end

  postgres do
    repo SoonReady.Repo
    table "onboarding__personally_identifiable_information__encryption_details"
  end
end
