defmodule SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationInitiatedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :first_name, :ci_string, allow_nil?: false
    attribute :last_name, :ci_string, allow_nil?: false
    attribute :username, :ci_string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
    attribute :password_confirmation, :string, allow_nil?: false
  end

  # TODO: Hash PII
  # TODO: Hash sensitive data

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement
    define :create
  end
end



# defmodule SoonReady.IdentityAndAccessManagement.Events.ResearcherRegisteredV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
#   require Logger
#   alias SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

#   attributes do
#     attribute :researcher_id, :uuid, allow_nil?: false, primary_key?: true
#     # TODO: Convert to relationship?
#     attribute :user_id, :uuid, allow_nil?: false
#     attribute :first_name_hash, :string, allow_nil?: false
#     attribute :last_name_hash, :string, allow_nil?: false
#   end

#   calculations do
#     calculate :first_name, :ci_string, fn record, _context ->
#       # TODO: Export to encryption context
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.user_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.first_name_hash}) do
#           {:ok, first_name} -> {:ok, Ash.CiString.new(first_name)}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end

#     calculate :last_name, :ci_string, fn record, _context ->
#       # TODO: Export to encryption context
#       # TODO: Run this only once
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.user_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.last_name_hash}) do
#           {:ok, last_name} -> {:ok, Ash.CiString.new(last_name)}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end
#   end

#   changes do
#     change load(:first_name)
#     change load(:last_name)
#   end

#   preparations do
#     prepare fn query, _context ->
#       query
#       |> Ash.Query.load(:first_name)
#       |> Ash.Query.load(:last_name)
#     end
#   end

#   actions do
#     create :create do
#       primary? true

#       argument :first_name, :string, allow_nil?: false
#       argument :last_name, :string, allow_nil?: false

#       change fn changeset, _context ->
#         user_id = Ash.Changeset.get_attribute(changeset, :user_id)
#         first_name = Ash.Changeset.get_argument(changeset, :first_name)
#         last_name = Ash.Changeset.get_argument(changeset, :last_name)

#         # TODO: Export to encryption context
#         with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.generate(%{id: user_id}) do
#           changeset =
#             case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: first_name}) do
#               {:ok, first_name_hash} ->
#                 Ash.Changeset.change_attribute(changeset, :first_name_hash, first_name_hash)
#               :error ->
#                 Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(:first_name)}, value: #{inspect(first_name)}")
#                 Ash.Changeset.add_error(changeset, [field: :first_name, message: "encryption failed", value: first_name])
#             end

#           case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: last_name}) do
#             {:ok, last_name_hash} ->
#               Ash.Changeset.change_attribute(changeset, :last_name_hash, last_name_hash)
#             :error ->
#               Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(:last_name)}, value: #{inspect(last_name)}")
#               Ash.Changeset.add_error(changeset, [field: :last_name, message: "encryption failed", value: last_name])
#           end
#         end
#       end
#     end

#     create :decrypt
#   end

#   code_interface do
#     define_for SoonReady.IdentityAndAccessManagement
#     define :create
#     define :decrypt
#   end
# end
