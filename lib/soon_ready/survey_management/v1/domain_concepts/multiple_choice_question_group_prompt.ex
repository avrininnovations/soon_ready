defmodule SoonReady.SurveyManagement.V1.DomainConcepts.MultipleChoiceQuestionGroupPrompt do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    uuid_primary_key :id, public?: true
    attribute :prompt, :ci_string, allow_nil?: false, public?: true
  end
end
