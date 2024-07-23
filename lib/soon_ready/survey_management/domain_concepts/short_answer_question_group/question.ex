defmodule SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestionGroup.Question do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :prompt, :ci_string, allow_nil?: true, public?: true
  end
end
