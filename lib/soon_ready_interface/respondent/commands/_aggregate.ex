defmodule SoonReadyInterface.Respondent.Commands.Aggregate do
  use Ash.Resource, domain: SoonReadyInterface.Respondent
  use Commanded.Commands.Router

  alias SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse
  alias SoonReady.SurveyManagement.V1.DomainEvents.{SurveyPublished, SurveyResponseSubmitted}

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :survey_id,
    ]
    defaults [:create]
  end

  code_interface do
    define :create
  end

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, responses: responses} = command) do
    SurveyResponseSubmitted.new(%{
      response_id: response_id,
      survey_id: survey_id,
      responses: responses,
    })
  end

  def apply(state, %SurveyPublished{survey_id: survey_id} = event) do
    __MODULE__.create!(%{survey_id: survey_id})
  end

  def apply(state, _event) do
    state
  end
end
