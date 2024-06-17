# defmodule SoonReady.SurveyManagement.Events.SurveyResponseSubmittedV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   require Logger
#   alias SoonReady.SurveyManagement.DomainConcepts.Response

#   # alias SoonReady.SurveyManagement.DomainConcepts.{Participant, HashedParticipant, QuestionResponse, JobStepRating}
#   # alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey


#   attributes do
#     attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :survey_id, :uuid, allow_nil?: false
#     attribute :responses, {:array, :map}
#   end

#   # calculations do
#   #   calculate :participant, Participant, fn record, _context ->
#   #     with {:ok, %{key: key}} <- PersonalIdentifiableInformationEncryptionKey.get(record.response_id),
#   #         {:ok, participant} <- decrypt_participant(record.hashed_participant, key)
#   #     do
#   #       {:ok, participant}
#   #     else
#   #       {:error, error} ->
#   #         Logger.warning("Decryption failed, #{inspect(error)}")
#   #         {:error, error}
#   #     end
#   #   end
#   # end

#   actions do
#     # create :new do
#     #   argument :participant, Participant

#     #   change fn changeset, _context ->
#     #     response_id = Ash.Changeset.get_attribute(changeset, :response_id)
#     #     participant = Ash.Changeset.get_argument(changeset, :participant)

#     #     with {:ok, %{key: key} = response_cloak_keys} <- PersonalIdentifiableInformationEncryptionKey.generate(%{id: response_id}) do
#     #       with {:ok, hashed_participant} <- encrypt_participant(participant, key) do
#     #         Ash.Changeset.change_attribute(changeset, :hashed_participant, hashed_participant)
#     #       else
#     #         {:error, error} ->
#     #           Logger.warning("Encryption failed, #{inspect(error)}")
#     #           PersonalIdentifiableInformationEncryptionKey.destroy!(response_cloak_keys)
#     #           {:error, error}
#     #       end
#     #     end
#     #   end
#     # end

#     # create :decrypt do
#     #   change load(:participant)
#     # end

#     defaults [:create, :read]
#     create :new
#     create :decrypt
#   end

#   code_interface do
#     define_for SoonReady.SurveyManagement
#     define :new
#     define :decrypt
#   end

#   # def encrypt_participant(participant, key) do
#   #   encrypt_value = fn
#   #     nil ->
#   #       {:ok, nil}
#   #     plain_text when is_binary(plain_text) ->
#   #       with :error <- SoonReady.Vault.encrypt(%{key: key, plain_text: plain_text}) do
#   #         {:error, :vault_encyption_error}
#   #       end
#   #     _ ->
#   #       {:error, :unknown_error}
#   #     end

#   #   with {:ok, nickname_hash} <- encrypt_value.(participant.nickname),
#   #         {:ok, email_hash} <- encrypt_value.(participant.email),
#   #         {:ok, phone_number_hash} <- encrypt_value.(participant.phone_number)
#   #   do
#   #     HashedParticipant.create(%{nickname_hash: nickname_hash, email_hash: email_hash, phone_number_hash: phone_number_hash})
#   #   end
#   # end

#   # def decrypt_participant(hashed_participant, key) do
#   #   decrypt_value = fn
#   #     nil ->
#   #       {:ok, nil}
#   #     cipher_text when is_binary(cipher_text) ->
#   #       with :error <- SoonReady.Vault.decrypt(%{key: key, cipher_text: cipher_text}) do
#   #         {:error, :vault_decryption_error}
#   #       end
#   #     _ ->
#   #       {:error, :unknown_error}
#   #     end

#   #   with {:ok, nickname} <- decrypt_value.(hashed_participant.nickname_hash),
#   #         {:ok, email} <- decrypt_value.(hashed_participant.email_hash),
#   #         {:ok, phone_number} <- decrypt_value.(hashed_participant.phone_number_hash)
#   #   do
#   #     Participant.create(%{nickname: nickname, email: email, phone_number: phone_number})
#   #   end
#   # end
# end
