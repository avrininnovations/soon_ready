defmodule SoonReady.SurveyManagement.ValueObjects.QuestionGroupResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.SimpleResponse

  attributes do
    attribute :prompt, :ci_string, allow_nil?: false
    attribute :response, {:array, SimpleResponse}, allow_nil?: false
  end
end
