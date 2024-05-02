defmodule SoonReady.OutcomeDrivenInnovation.Encryption.SurveyResponseCloakKeys do
  use Ash.Resource, data_layer: AshPostgres.DataLayer
  # TODO: Update to postgres

  require Logger

  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :encoded_cloak_key, :string, allow_nil?: false
  end

  calculations do
    calculate :decoded_cloak_key, :string, fn record, _context ->
      {:ok, Base.decode64!(record.encoded_cloak_key)}
    end
  end

  changes do
    change load(:decoded_cloak_key)
  end

  preparations do
    prepare fn query, _context ->
      Ash.Query.load(query, [:decoded_cloak_key])
    end
  end

  actions do
    defaults [:read, :destroy]

    create :initialize do
      primary? true

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :encoded_cloak_key, 32 |> :crypto.strong_rand_bytes() |> Base.encode64())
      end
    end

    read :get do
      get_by [:response_id]
    end
  end

  code_interface do
    define_for SoonReady.OutcomeDrivenInnovation.Survey
    define :initialize
    define :get, args: [:response_id]
    define :read
    define :destroy
  end

  # TODO: Update table name
  postgres do
    repo SoonReady.Repo
    table "quantifying_needs__survey_response__encryption__ciphers"
  end
end
