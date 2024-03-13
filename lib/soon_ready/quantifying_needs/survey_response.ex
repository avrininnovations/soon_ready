defmodule SoonReady.QuantifyingNeeds.SurveyResponse do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.SurveyResponse.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyingNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted
  alias SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher

  resources do
    resource SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher
  end

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :response_id

  defstruct [:response_id]

  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch

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

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: survey_response_id} = command) do
    with {:ok, cipher} <- Cipher.initialize(%{response_id: survey_response_id}) do
      with {:ok, nickname_hash} <- Cipher.encrypt_text(command.participant.nickname, cipher),
            {:ok, email_hash} <- Cipher.encrypt_text(command.participant.email, cipher),
            {:ok, phone_number_hash} <- Cipher.encrypt_text(command.participant.phone_number, cipher)
      do
        SurveyResponseSubmitted.new(%{
          response_id: command.response_id,
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
