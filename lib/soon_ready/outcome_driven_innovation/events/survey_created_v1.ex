defmodule SoonReady.OutcomeDrivenInnovation.Events.SurveyCreatedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.{
    Market,
    JobStep,
    SingleSelectQuestionWithCorrectOptions,
    MultipleChoiceQuestion,
    MultipleChoiceQuestion
  }

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :brand, :string
    attribute :market, Market
    attribute :job_steps, {:array, JobStep}
    attribute :screening_questions, {:array, SingleSelectQuestionWithCorrectOptions}
    attribute :demographic_questions, {:array, MultipleChoiceQuestion}
    attribute :context_questions, {:array, MultipleChoiceQuestion}
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.OutcomeDrivenInnovation
    define :new
  end
end
