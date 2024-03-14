defmodule SoonReady.QuantifyingNeeds.Survey do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.Survey.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.QuantifyingNeeds.Survey.DomainEvents.{SurveyCreated, SurveyPublished}

  alias SoonReady.QuantifyingNeeds.SurveyResponse.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyingNeeds.SurveyResponse.DomainEvents.SurveyResponseSubmitted
  alias SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher

  resources do
    resource SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  defstruct [:survey_id]

  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
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

  def execute(_aggregate_state, %CreateSurvey{} = command) do
    SurveyCreated.new(%{
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
    SurveyPublished.new(%{
      survey_id: command.survey_id
    })
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
