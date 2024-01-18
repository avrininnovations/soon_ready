defmodule SoonReady.QuantifyNeeds.SurveyResponse do
  use Ash.Resource, data_layer: :embedded

  require Logger
  alias SoonReady.QuantifyNeeds.SurveyResponse.ValueObjects.{Participant, Response, JobStep}
  alias SoonReady.QuantifyNeeds.SurveyResponse.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted
  alias SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher

  attributes do
    uuid_primary_key :id
    attribute :survey_id, :uuid, allow_nil?: false
    attribute :participant, Participant, allow_nil?: false
    attribute :screening_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :comparison_responses, {:array, Response}, allow_nil?: false, constraints: [min_length: 1]
    attribute :desired_outcome_ratings, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
  end

  actions do
    create :submit do
      # TODO: Validate that the survey is published

      change fn changeset, _context ->
        Ash.Changeset.after_action(changeset, fn changeset, result ->
          result
          |> Map.from_struct()
          |> SubmitSurveyResponse.dispatch()
          |> case do
            {:ok, _command} ->
              {:ok, result}

            {:error, error} ->
              changeset = Ash.Changeset.add_error(changeset, error)
              {:error, changeset}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
    define :submit
  end

  def decrypt_participant_details(survey_response_id, %{nickname_hash: nickname_hash, email_hash: email_hash, phone_number_hash: phone_number_hash}) do
    with {:ok, nickname} <- Cipher.decrypt_text(nickname_hash, for: survey_response_id),
         {:ok, email} <- Cipher.decrypt_text(email_hash, for: survey_response_id),
         {:ok, phone_number} <- Cipher.decrypt_text(phone_number_hash, for: survey_response_id)
    do
      %{nickname: nickname, email: email, phone_number: phone_number}
    else
      {:error, error} ->
        Logger.warning("Decryption failed, #{inspect(error)}")
        {:error, error}
    end
  end


  # Command Handling
  use Commanded.Commands.Router
  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :id

  def execute(_aggregate_state, %SubmitSurveyResponse{id: survey_response_id} = command) do
    with {:ok, cipher} <- Cipher.initialize(%{id: survey_response_id}) do
      with {:ok, nickname_hash} <- Cipher.encrypt_text(command.participant.nickname, cipher),
            {:ok, email_hash} <- Cipher.encrypt_text(command.participant.email, cipher),
            {:ok, phone_number_hash} <- Cipher.encrypt_text(command.participant.phone_number, cipher)
      do
        SurveyResponseSubmitted.new(%{
          id: command.id,
          survey_id: command.survey_id,
          participant: %{nickname_hash: nickname_hash, email_hash: email_hash, phone_number_hash: phone_number_hash},
          screening_responses: command.screening_responses,
          demographic_responses: command.demographic_responses,
          context_responses: command.context_responses,
          comparison_responses: command.comparison_responses,
          desired_outcome_ratings: command.desired_outcome_ratings
        })
      else
        {:error, error} ->
          Logger.warning("Encryption failed, #{inspect(error)}")
          Cipher.destroy!(cipher)
          {:error, error}
      end
    end
  end

  def apply(state, _event) do
    state
  end
end
