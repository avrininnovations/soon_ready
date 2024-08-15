defmodule SoonReady.OutcomeDrivenInnovation.ResearchProject do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation
  use Commanded.Commands.Router

  alias SoonReady.OutcomeDrivenInnovation.Commands.{
    CreateSurvey,
    MarkSurveyCreationAsSuccessful,
  }
  alias SoonReady.OutcomeDrivenInnovation.DomainEvents.{
    ProjectCreatedV1,
    MarketDefinedV1,
    NeedsDefinedV1,
    SurveyCreationRequestedV1,
    SurveyCreationSucceededV1,
  }

  alias SoonReady.SurveyManagement.{DomainEvents, IntegrationEvents}
  alias SoonReady.SurveyManagement.DomainEvents.SurveyCreatedV1

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }

  alias SoonReadyInterface.Researcher.ProcessManager.SurveyCreationProcessManager

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
  end

  actions do
    default_accept [
      :project_id,
      :market,
      :job_steps,
    ]
    defaults [:create, :read, :update]
  end

  code_interface do
    define :create
    define :update
  end

  dispatch CreateSurvey, to: __MODULE__, identity: :project_id
  dispatch MarkSurveyCreationAsSuccessful, to: __MODULE__, identity: :project_id

  def execute(aggregate_state, %CreateSurvey{} = command) do
    %{
      project_id: project_id,
      survey_id: survey_id,
      brand_name: brand_name,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
      survey: survey,
      trigger: trigger,
      pages_dumped_data: pages_dumped_data
    } = command

    with {:ok, project_created_event} <- ProjectCreatedV1.new(%{project_id: project_id, brand_name: brand_name}),
          {:ok, market_defined_event} <- MarketDefinedV1.new(%{project_id: project_id, market: market}),
          {:ok, needs_defined_event} <- NeedsDefinedV1.new(%{project_id: project_id, job_steps: job_steps}),
          {:ok, survey_created_event} <- SurveyCreatedV1.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages: survey.pages, trigger: trigger}),
          {:ok, survey_published_domain_event} <- DomainEvents.SurveyPublishedV1.new(%{survey_id: survey.survey_id}),
          {:ok, survey_published_integration_event} <- IntegrationEvents.SurveyPublishedV1.new(%{survey_id: survey.survey_id, starting_page_id: survey.starting_page_id, pages_dumped_data: pages_dumped_data, trigger: trigger})

          # {:ok, %{survey_id: ^survey_id}} <- SurveyCreationProcessManager.create_and_publish_survey(params),
          # {:ok, survey_creation_requested_event} <- SurveyCreationRequestedV1.new(%{project_id: project_id, survey_id: survey_id})
    do
      [project_created_event, market_defined_event, needs_defined_event, survey_created_event, survey_published_domain_event, survey_published_integration_event]
    end
  end

  def execute(_aggregate_state, %MarkSurveyCreationAsSuccessful{project_id: project_id, survey_id: survey_id} = command) do
    SurveyCreationSucceededV1.new(%{project_id: project_id, survey_id: survey_id})
  end

  def apply(state, _event) do
    state
  end
end
