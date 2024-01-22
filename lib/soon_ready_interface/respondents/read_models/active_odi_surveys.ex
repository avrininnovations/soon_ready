defmodule SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.QuantifyNeeds.Survey.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  alias SoonReady.QuantifyNeeds.Survey.DomainEvents.OdiSurveyPublished

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}
  end

  actions do
    defaults [:create, :read]

    read :get do
      get_by :id
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create

    define :read

    define :get do
      args [:id]
    end
  end

  postgres do
    repo SoonReady.Repo
    table "respondents__read_models__active_odi_surveys"
  end

  def handle(%OdiSurveyPublished{} = event, _metadata) do
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
end
