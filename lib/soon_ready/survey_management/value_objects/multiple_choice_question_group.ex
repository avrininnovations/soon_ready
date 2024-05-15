defmodule SoonReady.SurveyManagement.ValueObjects.MultipleChoiceQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.MultipleChoiceQuestion

  attributes do
    attribute :prompt, :ci_string, allow_nil?: false
    attribute :statements, {:array, :ci_string}, allow_nil?: false, constraints: [min_length: 2]
    attribute :questions, {:array, MultipleChoiceQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end
end
