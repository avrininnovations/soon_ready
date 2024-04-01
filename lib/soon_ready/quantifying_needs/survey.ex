defmodule SoonReady.QuantifyingNeeds.Survey do
  use Ash.Api
  use Commanded.Commands.Router

  alias SoonReady.QuantifyingNeeds.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.QuantifyingNeeds.DomainEvents.{SurveyCreatedV1, SurveyPublishedV1}

  alias SoonReady.QuantifyingNeeds.Commands.SubmitSurveyResponse
  alias SoonReady.QuantifyingNeeds.DomainEvents.SurveyResponseSubmittedV1
  alias SoonReady.QuantifyingNeeds.Cipher
  alias SoonReady.QuantifyingNeeds.Encryption.ResponseCloakKeys

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
    SurveyResponseSubmittedV1.new(%{
      response_id: command.response_id,
      survey_id: command.survey_id,
      participant: command.participant,
      screening_responses: command.screening_responses,
      demographic_responses: command.demographic_responses,
      context_responses: command.context_responses,
      comparison_responses: command.comparison_responses,
      desired_outcome_ratings: command.desired_outcome_ratings
    })
  end

  def apply(state, _event) do
    state
  end
end
