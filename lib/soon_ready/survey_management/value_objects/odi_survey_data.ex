defmodule SoonReady.SurveyManagement.ValueObjects.OdiSurveyData do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.{
    Market,
    JobStep,
    ScreeningQuestion,
    DemographicQuestion,
    ContextQuestion
  }

  attributes do
    attribute :brand, :string, allow_nil?: false
    attribute :market, Market, allow_nil?: false
    attribute :job_steps, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
    attribute :screening_questions, {:array, ScreeningQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :demographic_questions, {:array, DemographicQuestion}, allow_nil?: false, constraints: [min_length: 1]
    attribute :context_questions, {:array, ContextQuestion}, allow_nil?: false, constraints: [min_length: 1]
  end
end
