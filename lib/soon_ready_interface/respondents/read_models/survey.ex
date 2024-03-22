defmodule SoonReadyInterface.Respondents.ReadModels.Survey do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias SoonReady.QuantifyingNeeds.Survey.ValueObjects.{
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
    table "respondents__read_models__odi_surveys"
  end
end
