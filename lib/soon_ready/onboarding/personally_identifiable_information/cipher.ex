# defmodule SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher do
#   @behaviour Cloak.Cipher

#   require Logger
#   alias SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

#   @impl true
#   def encrypt(%{person_id: person_id, plain_text: plain_text}, opts) when is_binary(plain_text) do
#     case EncryptionDetails.get_key(person_id) do
#       {:ok, key} ->
#         opts = put_in(opts[:key], key)

#         with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
#           {:ok, Base.encode64(cipher_text)}
#         end
#       {:error, error} ->
#         Logger.warning("Encryption failed for person_id: #{person_id}. Error: #{error}")
#         :error
#     end
#   end

#   def encrypt(_value, _opts) do
#     Logger.warning("Encryption failed")
#     :error
#   end

#   @impl true
#   def decrypt(%{person_id: person_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
#     case EncryptionDetails.get_key(person_id) do
#       {:ok, key} ->
#         opts = put_in(opts[:key], key)

#         cipher_text
#         |> Base.decode64!()
#         |> Cloak.Ciphers.AES.GCM.decrypt(opts)
#       {:error, error} ->
#         Logger.warning("Decryption failed for person_id: #{person_id}. Error: #{error}")
#         :error
#     end
#   end

#   def decrypt(_value, _opts) do
#     Logger.warning("Decryption failed")
#     :error
#   end

#   @impl true
#   def can_decrypt?(%{person_id: person_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
#     case EncryptionDetails.get_key(person_id) do
#       {:ok, key} ->
#         opts = put_in(opts[:key], key)

#         cipher_text
#         |> Base.decode64!()
#         |> Cloak.Ciphers.AES.GCM.can_decrypt?(opts)
#       {:error, _error} ->
#         false
#     end
#   end

#   def can_decrypt?(_value, _opts) do
#     false
#   end
# end
