defmodule SoonReady.QuantifyingNeeds.Survey do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.Survey.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.{SurveyCreatedV1, SurveyPublishedV1}

  alias SoonReady.QuantifyingNeeds.Survey.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.SurveyResponseSubmittedV1
  alias SoonReady.QuantifyingNeeds.Cipher
  alias SoonReady.QuantifyingNeeds.Survey.Encryption.ResponseCloakKeys

  resources do
    resource ResponseCloakKeys
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  defstruct [:survey_id]

  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
  defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch

  def decrypt_participant_details(response_id, %{nickname_hash: nickname_hash, email_hash: email_hash, phone_number_hash: phone_number_hash}) do
    with {:ok, nickname} <- Cipher.decrypt_response_data(nickname_hash, for: response_id),
         {:ok, email} <- Cipher.decrypt_response_data(email_hash, for: response_id),
         {:ok, phone_number} <- Cipher.decrypt_response_data(phone_number_hash, for: response_id)
    do
      %{nickname: nickname, email: email, phone_number: phone_number}
    else
      {:error, error} ->
        Logger.warning("Decryption failed, #{inspect(error)}")
        {:error, error}
    end
  end

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreatedV1.new(%{
      survey_id: command.survey_id,
      brand: command.brand,
      market: command.market,
      job_steps: command.job_steps,
      screening_questions: command.screening_questions,
      demographic_questions: command.demographic_questions,
      context_questions: command.context_questions
    })
  end

  def execute(_aggregate_state, %PublishSurvey{} = command) do
    SurveyPublishedV1.new(%{
      survey_id: command.survey_id
    })
  end

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id} = command) do
    with {:ok, cloak_keys} <- ResponseCloakKeys.initialize(%{response_id: response_id}) do
      with {:ok, nickname_hash} <- Cipher.encrypt_response_data(command.participant.nickname, cloak_keys),
            {:ok, email_hash} <- Cipher.encrypt_response_data(command.participant.email, cloak_keys),
            {:ok, phone_number_hash} <- Cipher.encrypt_response_data(command.participant.phone_number, cloak_keys)
      do
        SurveyResponseSubmittedV1.new(%{
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
          ResponseCloakKeys.destroy!(cloak_keys)
          {:error, error}
      end
    end
  end

  def apply(state, _event) do
    state
  end
end
