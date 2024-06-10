defmodule SoonReady.SurveyManagement.DomainConcepts.MultipleChoiceQuestionGroupResponses.SingleResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :prompt_id, :uuid, allow_nil?: false
    attribute :question_id, :uuid, allow_nil?: false
    attribute :response, :ci_string, allow_nil?: false
  end
end
