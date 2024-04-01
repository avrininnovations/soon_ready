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
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :new
  end
end
