defmodule SoonReadyInterface.Respondents.Commands.Handlers.Survey do
  use Ash.Resource, domain: SoonReadyInterface.Respondents
  use Commanded.Commands.Router

  alias SoonReady.SurveyManagement.DomainEvents
  alias SoonReady.SurveyManagement.IntegrationEvents

  alias SoonReady.SurveyManagement.DomainEvents.SurveyCreatedV1

  alias SoonReadyInterface.Respondents.Commands.SubmitSurveyResponse
  alias SoonReady.SurveyManagement.DomainEvents.SurveyResponseSubmittedV1

  alias SoonReady.SurveyManagement.DomainConcepts.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :starting_page_id, :uuid, allow_nil?: false, public?: true
    attribute :pages, {:array, SurveyPage}, public?: true
    attribute :trigger, Trigger
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages,
      :trigger,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, raw_responses_data: raw_responses_data} = command) do
    SurveyResponseSubmittedV1.new(%{
      response_id: response_id,
      survey_id: survey_id,
      responses: raw_responses_data,
    })
  end

  def apply(state, %SurveyCreatedV1{survey_id: survey_id, starting_page_id: starting_page_id, pages: pages, trigger: trigger}) do
    __MODULE__.create!(%{survey_id: survey_id, starting_page_id: starting_page_id, pages: pages, trigger: trigger})
  end

  def apply(state, _event) do
    state
  end
end
