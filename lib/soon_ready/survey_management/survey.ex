defmodule SoonReady.SurveyManagement.Survey do
  use Ash.Resource, domain: SoonReady.SurveyManagement
  use Commanded.Commands.Router

  alias SoonReady.SurveyManagement.DomainEvents
  alias SoonReady.SurveyManagement.IntegrationEvents

  alias SoonReady.SurveyManagement.Commands.{CreateSurvey, PublishSurvey}
  alias SoonReady.SurveyManagement.DomainEvents.SurveyCreatedV1

  alias SoonReady.SurveyManagement.Commands.SubmitSurveyResponse
  alias SoonReady.SurveyManagement.DomainEvents.SurveyResponseSubmittedV1

  alias SoonReady.SurveyManagement.DomainConcepts.Trigger

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :trigger, Trigger
  end

  actions do
    default_accept [
      :survey_id,
      :trigger,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :survey_id
  dispatch PublishSurvey, to: __MODULE__, identity: :survey_id
  dispatch SubmitSurveyResponse, to: __MODULE__, identity: :survey_id

  # # TODO: Do something about this need to use raw data
  def execute(_aggregate_state, %CreateSurvey{survey_id: survey_id, starting_page_id: starting_page_id, raw_pages_data: raw_pages_data, trigger: trigger} = _command) do
    SurveyCreatedV1.new(%{survey_id: survey_id, starting_page_id: starting_page_id, pages: raw_pages_data, trigger: trigger})
  end

  def execute(aggregate_state, %PublishSurvey{survey_id: survey_id} = _command) do
    with {:ok, domain_event} <- DomainEvents.SurveyPublishedV1.new(%{survey_id: survey_id}),
          {:ok, integration_event} <- IntegrationEvents.SurveyPublishedV1.new(%{survey_id: survey_id, trigger: aggregate_state.trigger})
    do
      {:ok, [domain_event, integration_event]}
    end
  end

  def execute(_aggregate_state, %SubmitSurveyResponse{response_id: response_id, survey_id: survey_id, raw_responses_data: raw_responses_data} = command) do
    SurveyResponseSubmittedV1.new(%{
      response_id: response_id,
      survey_id: survey_id,
      responses: raw_responses_data,
    })
  end

  def apply(state, %SurveyCreatedV1{survey_id: survey_id, trigger: trigger}) do
    __MODULE__.create!(%{survey_id: survey_id, trigger: trigger})
  end

  def apply(state, _event) do
    state
  end
end
