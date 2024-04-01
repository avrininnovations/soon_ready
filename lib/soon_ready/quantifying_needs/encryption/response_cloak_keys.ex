defmodule SoonReady.QuantifyingNeeds.Encryption.ResponseCloakKeys do
  use Ash.Resource, data_layer: AshPostgres.DataLayer
  # TODO: Update to postgres

  require Logger

  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :cloak_key, :string, allow_nil?: false
  end

  actions do
    defaults [:read, :destroy]

    create :initialize do
      primary? true

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :cloak_key, 32 |> :crypto.strong_rand_bytes() |> Base.encode64())
      end
    end

    read :get do
      get_by [:response_id]
    end
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :initialize
    define :get
    define :read
    define :destroy
  end

  # TODO: Update table name
  postgres do
    repo SoonReady.Repo
    table "quantifying_needs__survey_response__encryption__ciphers"
  end

  def get_key(response_id) do
    with {:ok, %{__struct__: __MODULE__, cloak_key: cloak_key}} <- __MODULE__.get(%{response_id: response_id}) do
      {:ok, Base.decode64!(cloak_key)}
    end
  end
end
