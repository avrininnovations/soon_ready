defmodule SoonReady.OutcomeDrivenInnovation.ResearchProject do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation
  use Commanded.Commands.Router

  alias SoonReady.OutcomeDrivenInnovation.Commands.{
    CreateProject,
    DefineMarket,
    DefineNeeds,
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

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.{
    Market,
    JobStep,
  }

  alias SoonReady.OutcomeDrivenInnovation.Resources.SurveyManager

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

  dispatch CreateProject, to: __MODULE__, identity: :project_id
  dispatch DefineMarket, to: __MODULE__, identity: :project_id
  dispatch DefineNeeds, to: __MODULE__, identity: :project_id
  dispatch CreateSurvey, to: __MODULE__, identity: :project_id
  dispatch MarkSurveyCreationAsSuccessful, to: __MODULE__, identity: :project_id

  def execute(_aggregate_state, %CreateProject{project_id: project_id, brand_name: brand_name} = _command) do
    ProjectCreatedV1.new(%{
      project_id: project_id,
      brand_name: brand_name,
    })
  end

  def execute(_aggregate_state, %DefineMarket{project_id: project_id, market: market} = _command) do
    MarketDefinedV1.new(%{
      project_id: project_id,
      market: market,
    })
  end

  def execute(_aggregate_state, %DefineNeeds{project_id: project_id, job_steps: job_steps} = _command) do
    NeedsDefinedV1.new(%{
      project_id: project_id,
      job_steps: job_steps,
    })
  end

  def execute(aggregate_state, %CreateSurvey{} = command) do
    params = %{
      project_id: command.project_id,
      survey_id: command.survey_id,
      market: aggregate_state.market,
      job_steps: aggregate_state.job_steps,
      screening_questions: command.raw_screening_questions,
      demographic_questions: command.raw_demographic_questions,
      context_questions: command.raw_context_questions,
      trigger: %{name: CreateSurvey, id: command.project_id}
    }

    with {:ok, %{survey_id: survey_id}} <- SurveyManager.create_and_publish_survey(params) do
      SurveyCreationRequestedV1.new(%{
        project_id: command.project_id,
        survey_id: survey_id,
      })
    end
  end

  def execute(_aggregate_state, %MarkSurveyCreationAsSuccessful{project_id: project_id, survey_id: survey_id} = command) do
    SurveyCreationSucceededV1.new(%{project_id: project_id, survey_id: survey_id})
  end

  def apply(state, %ProjectCreatedV1{project_id: project_id}) do
    __MODULE__.create!(%{project_id: project_id})
  end

  def apply(state, %MarketDefinedV1{market: market}) do
    __MODULE__.update!(state, %{market: market})
  end

  def apply(state, %NeedsDefinedV1{job_steps: job_steps}) do
    __MODULE__.update!(state, %{job_steps: job_steps})
  end

  def apply(state, _event) do
    state
  end
end
