defmodule SoonReady.QuantifyNeeds.Survey.DomainEvents.SurveyCreated do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.{
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
    attribute :event_version, :integer, allow_nil?: false, default: 1
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.Survey.Api
    define :new
  end
end
