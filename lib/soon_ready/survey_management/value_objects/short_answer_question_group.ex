defmodule SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestion

  attributes do
    attribute :prompt, :ci_string, allow_nil?: false
    attribute :questions, {:array, ShortAnswerQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end
end
