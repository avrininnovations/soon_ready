defmodule SoonReady.SurveyManagement.V1.DomainConcepts.ParagraphQuestionResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Check nility of all response types
  attributes do
    attribute :question_id, :uuid, allow_nil?: false, public?: true
    attribute :response, :ci_string, public?: true
  end
end
