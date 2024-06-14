# defmodule SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationInitiatedV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder], api: SoonReady.IdentityAndAccessManagement
#   require Logger
#   alias SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

#   attributes do
#     attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
#     attribute :first_name_hash, :string, allow_nil?: false
#     attribute :last_name_hash, :string, allow_nil?: false
#     attribute :username_hash, :string, allow_nil?:  false
#     attribute :password_hash, :string, allow_nil?: false
#     attribute :password_confirmation_hash, :string, allow_nil?: false
#   end

#   actions do
#     defaults [:read]
#     create :create do
#       primary? true

#       argument :first_name, :ci_string, allow_nil?: false
#       argument :last_name, :ci_string, allow_nil?: false
#       argument :username, :ci_string, allow_nil?:  false
#       argument :password, :string, allow_nil?: false
#       argument :password_confirmation, :string, allow_nil?: false

#       change fn changeset, _context ->
#         researcher_id = Ash.Changeset.get_attribute(changeset, :researcher_id)
#         first_name = Ash.Changeset.get_argument(changeset, :first_name)
#         last_name = Ash.Changeset.get_argument(changeset, :last_name)
#         username = Ash.Changeset.get_argument(changeset, :username)
#         password = Ash.Changeset.get_argument(changeset, :password)
#         password_confirmation = Ash.Changeset.get_argument(changeset, :password_confirmation)

#         # TODO: Export to encryption context
#         with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.generate(%{id: researcher_id}) do
#           changeset =
#             changeset
#             |> encrypt(encryption_key, :first_name, first_name, :first_name_hash)
#             |> encrypt(encryption_key, :last_name, last_name, :last_name_hash)
#             |> encrypt(encryption_key, :username, username, :username_hash)
#             |> encrypt(encryption_key, :password, password, :password_hash)
#             |> encrypt(encryption_key, :password_confirmation, password_confirmation, :password_confirmation_hash)
#         end
#       end
#     end

#     create :decrypt
#   end

#   calculations do
#     calculate :first_name, :ci_string, fn record, _context ->
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.first_name_hash}) do
#           {:ok, first_name} -> {:ok, Ash.CiString.new(first_name)}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end

#     calculate :last_name, :ci_string, fn record, _context ->
#       # TODO: Run this only once
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.last_name_hash}) do
#           {:ok, last_name} -> {:ok, Ash.CiString.new(last_name)}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end

#     calculate :username, :ci_string, fn record, _context ->
#       # TODO: Run this only once
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.username_hash}) do
#           {:ok, username} -> {:ok, Ash.CiString.new(username)}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end

#     calculate :password, :string, fn record, _context ->
#       # TODO: Run this only once
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.password_hash}) do
#           {:ok, password} -> {:ok, password}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end

#     calculate :password_confirmation, :string, fn record, _context ->
#       # TODO: Run this only once
#       with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(record.researcher_id) do
#         case SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: record.password_confirmation_hash}) do
#           {:ok, password_confirmation} -> {:ok, password_confirmation}
#           :error -> {:error, :decryption_error}
#         end
#       end
#     end
#   end

#   changes do
#     change load(:first_name)
#     change load(:last_name)
#     change load(:username)
#     change load(:password)
#     change load(:password_confirmation)
#   end

#   preparations do
#     prepare fn query, _context ->
#       query
#       |> Ash.Query.load(:first_name)
#       |> Ash.Query.load(:last_name)
#       |> Ash.Query.load(:username)
#       |> Ash.Query.load(:password)
#       |> Ash.Query.load(:password_confirmation)
#     end
#   end

#   def encrypt(changeset, encryption_key, plain_argument_name, plain_text, hash_attribute_name) do
#     case SoonReady.Vault.encrypt(%{key: encryption_key, plain_text: to_string(plain_text)}) do
#       {:ok, cipher_text} ->
#         Ash.Changeset.change_attribute(changeset, hash_attribute_name, cipher_text)
#       :error ->
#         Logger.warning("Encryption failed -- module: #{inspect(__MODULE__)}, field: #{inspect(plain_argument_name)}, value: #{inspect(plain_text)}")
#         Ash.Changeset.add_error(changeset, [field: plain_argument_name, message: "encryption failed", value: plain_text])
#     end
#   end

#   code_interface do
#     define_for SoonReady.IdentityAndAccessManagement
#     define :create
#     define :decrypt
#   end
# end
