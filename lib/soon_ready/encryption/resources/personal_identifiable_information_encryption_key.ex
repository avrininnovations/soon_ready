defmodule SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey do
  use Ash.Resource,
    domain: SoonReady.Encryption,
    data_layer: AshPostgres.DataLayer

  require Logger

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :encoded_key, :string, allow_nil?: false
  end

  calculations do
    calculate :key, :string, fn [record], _context ->
      {:ok, [Base.decode64!(record.encoded_key)]}
    end
  end

  changes do
    change load(:key)
  end

  preparations do
    prepare fn query, _context ->
      Ash.Query.load(query, [:key])
    end
  end

  actions do
    default_accept [:id]
    defaults [:read, :destroy]

    create :generate do
      primary? true

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :encoded_key, 32 |> :crypto.strong_rand_bytes() |> Base.encode64())
      end
    end

    read :get do
      get_by [:id]
    end
  end

  code_interface do
    define :generate
    define :get, args: [:id]
    define :read
    define :destroy
  end

  postgres do
    # TODO: Rename table
    repo SoonReady.Repo
    table "encryption__personal_identifiable_information_encryption_key"
  end
end
