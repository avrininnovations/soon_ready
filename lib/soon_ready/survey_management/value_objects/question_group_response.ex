defmodule SoonReady.SurveyManagement.ValueObjects.QuestionGroupResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.SimpleResponse

  attributes do
    attribute :question_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :response, {:array, SimpleResponse}, allow_nil?: false
  end
end
