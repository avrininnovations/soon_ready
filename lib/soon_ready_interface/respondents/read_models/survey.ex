defmodule SoonReadyInterface.Respondents.ReadModels.Survey do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}
    attribute :is_active, :boolean, allow_nil?: false, default: false
  end

  actions do
    defaults [:create, :read, :update]

    read :get do
      get_by :id
    end

    read :get_active do
      get_by :id
      filter expr(is_active == true)
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create

    define :read

    define :get do
      args [:id]
    end

    define :get_active do
      args [:id]
    end

    define :update
  end

  # TODO: Check all postgres names for issues
  postgres do
    repo SoonReady.Repo
    table "respondents__read_models__survey"
  end


  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.OutcomeDrivenInnovation.Events.{SurveyCreatedV1, SurveyPublishedV1}

  def handle(%SurveyCreatedV1{} = event, _metadata) do
    %{
      survey_id: survey_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    } = event

    with {:ok, _active_odi_survey} <- __MODULE__.create(%{
      id: survey_id,
      brand: brand,
      market: market,
      job_steps: job_steps,
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions
    }) do
      :ok
    end
  end

  def handle(%SurveyPublishedV1{survey_id: survey_id} = _event, _metadata) do
    # TODO: Refactor this not to need query?
    with {:ok, odi_survey} <- __MODULE__.get(survey_id),
          {:ok, _odi_survey} <- __MODULE__.update(odi_survey, %{is_active: true})
    do
      :ok
    end
  end
end
