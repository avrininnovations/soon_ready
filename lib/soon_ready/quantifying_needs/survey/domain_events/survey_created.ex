defmodule SoonReady.QuantifyingNeeds.Survey.DomainEvents.SurveyCreated do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.QuantifyingNeeds.Survey.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, ScreeningQuestion}
    attribute :demographic_questions, {:array, DemographicQuestion}
    attribute :context_questions, {:array, ContextQuestion}

    # TODO: Work on versioning events. Is this the version better expressed in the module name
    # Considerations:
    #   Can I have the old shape of the events preserved?
    #   How does the elixir type system affect protocols since upcasting
    #   is done in protocols and the struct shape will change?
    attribute :event_version, :integer, allow_nil?: false, default: 1
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :new
  end
end
