defmodule SoonReady.QuantifyingNeeds.SurveyResponse do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.SurveyResponse.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyingNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted
  alias SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :id

  defstruct [:id]

  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch

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
