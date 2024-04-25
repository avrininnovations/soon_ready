defmodule SoonReady.IdentityAndAccessManagement.Events.ResearcherRegisteredV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  require Logger
  alias SoonReady.IdentityAndAccessManagement.Resources.PiiEncryptionKey

  attributes do
    attribute :researcher_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :user_id, :uuid, allow_nil?: false
    attribute :first_name_hash, :string, allow_nil?: false
    attribute :last_name_hash, :string, allow_nil?: false
  end

  actions do
    create :create do
      primary? true

      argument :first_name, :string, allow_nil?: false
      argument :last_name, :string, allow_nil?: false

      change fn changeset, _context ->
        user_id = Ash.Changeset.get_attribute(changeset, :user_id)
        first_name = Ash.Changeset.get_argument(changeset, :first_name)
        last_name = Ash.Changeset.get_argument(changeset, :last_name)

        with {:ok, %{key: encryption_key} = _user_encryption_key} <- PiiEncryptionKey.generate(%{user_id: user_id}) do
          changeset =
            case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: first_name}) do
              {:ok, first_name_hash} ->
                Ash.Changeset.change_attribute(changeset, :first_name_hash, first_name_hash)
              :error ->
                Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(:first_name)}, value: #{inspect(first_name)}")
                Ash.Changeset.add_error(changeset, [field: :first_name, message: "encryption failed", value: first_name])
            end

          case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: last_name}) do
            {:ok, last_name_hash} ->
              Ash.Changeset.change_attribute(changeset, :last_name_hash, last_name_hash)
            :error ->
              Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(:last_name)}, value: #{inspect(last_name)}")
              Ash.Changeset.add_error(changeset, [field: :last_name, message: "encryption failed", value: last_name])
          end
        end
      end
    end
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement.Api
    define :create
  end
end
