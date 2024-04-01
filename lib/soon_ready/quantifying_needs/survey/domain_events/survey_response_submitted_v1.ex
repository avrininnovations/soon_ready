defmodule SoonReady.QuantifyingNeeds.Survey.DomainEvents.SurveyResponseSubmittedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.Survey.ValueObjects.{Participant, HashedParticipant, QuestionResponse, JobStepRating}
  alias SoonReady.QuantifyingNeeds.Cipher
  alias SoonReady.QuantifyingNeeds.Survey.Encryption.ResponseCloakKeys


  attributes do
    attribute :response_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :survey_id, :uuid
    attribute :hashed_participant, HashedParticipant
    attribute :screening_responses, {:array, QuestionResponse}
    attribute :demographic_responses, {:array, QuestionResponse}
    attribute :context_responses, {:array, QuestionResponse}
    attribute :comparison_responses, {:array, QuestionResponse}
    attribute :desired_outcome_ratings, {:array, JobStepRating}
  end

  calculations do
    calculate :participant, Participant, fn record, _arg2 ->
      with {:ok, nickname} <- Cipher.decrypt_response_data(record.hashed_participant.nickname_hash, for: record.response_id),
          {:ok, email} <- Cipher.decrypt_response_data(record.hashed_participant.email_hash, for: record.response_id),
          {:ok, phone_number} <- Cipher.decrypt_response_data(record.hashed_participant.phone_number_hash, for: record.response_id)
      do
        Participant.create( %{nickname: nickname, email: email, phone_number: phone_number})
      else
        {:error, error} ->
          Logger.warning("Decryption failed, #{inspect(error)}")
          {:error, error}
      end
    end
  end

  actions do
    create :new do
      argument :participant, Participant

      change fn changeset, _context ->
        response_id = Ash.Changeset.get_attribute(changeset, :response_id)
        participant = Ash.Changeset.get_argument(changeset, :participant)

        with {:ok, cloak_keys} <- ResponseCloakKeys.initialize(%{response_id: response_id}) do
          with {:ok, nickname_hash} <- Cipher.encrypt_response_data(participant.nickname, cloak_keys),
                {:ok, email_hash} <- Cipher.encrypt_response_data(participant.email, cloak_keys),
                {:ok, phone_number_hash} <- Cipher.encrypt_response_data(participant.phone_number, cloak_keys)
          do
            Ash.Changeset.change_attribute(changeset, :hashed_participant, %{nickname_hash: nickname_hash, email_hash: email_hash, phone_number_hash: phone_number_hash})
          else
            {:error, error} ->
              Logger.warning("Encryption failed, #{inspect(error)}")
              ResponseCloakKeys.destroy!(cloak_keys)
              {:error, error}
          end
        end
      end
    end

    create :decrypt do
      change load(:participant)
    end
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :new
    define :decrypt
  end
end
