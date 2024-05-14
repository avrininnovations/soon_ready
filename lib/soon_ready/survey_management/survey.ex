defmodule SoonReady.SurveyManagement.Survey do
  use Ash.Resource
  use Commanded.Commands.Router

  alias SoonReady.SurveyManagement.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.SurveyManagement.Events.{SurveyCreatedV1, SurveyPublishedV1}

  alias SoonReady.SurveyManagement.Commands.SubmitSurveyResponse
  alias SoonReady.SurveyManagement.Events.SurveyResponseSubmittedV1

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id
  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  def execute(_aggregate_state, %CreateSurvey{survey_id: survey_id, pages: pages} = _command) do
    SurveyCreatedV1.new(%{survey_id: survey_id, pages: pages})
  end

  def execute(_aggregate_state, %PublishSurvey{survey_id: survey_id} = _command) do
    SurveyPublishedV1.new(%{survey_id: survey_id})
  end

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id} = command) do
    SurveyResponseSubmittedV1.new(%{
      response_id: response_id,
      survey_id: survey_id,
      # participant: command.participant,
      # screening_responses: command.screening_responses,
      # demographic_responses: command.demographic_responses,
      # context_responses: command.context_responses,
      # comparison_responses: command.comparison_responses,
      # desired_outcome_ratings: command.desired_outcome_ratings
    })
  end

  def apply(state, _event) do
    state
  end
end
