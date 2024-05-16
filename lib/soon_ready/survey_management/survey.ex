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

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, raw_responses_data: raw_responses_data} = command) do
    SurveyResponseSubmittedV1.new(%{
      response_id: response_id,
      survey_id: survey_id,
      responses: raw_responses_data,
    })
  end

  def apply(state, _event) do
    state
  end
end
