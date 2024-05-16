defmodule SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestionGroupResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestionResponse

  attributes do
    attribute :question_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :response, {:array, ShortAnswerQuestionResponse}, allow_nil?: false
  end
end
