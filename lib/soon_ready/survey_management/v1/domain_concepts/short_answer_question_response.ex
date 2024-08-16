defmodule SoonReady.SurveyManagement.V1.DomainConcepts.ShortAnswerQuestionResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :question_id, :uuid, allow_nil?: false, public?: true
    attribute :response, :ci_string, public?: true
  end
end
