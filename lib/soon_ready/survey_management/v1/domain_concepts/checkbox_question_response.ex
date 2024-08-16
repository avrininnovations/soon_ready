defmodule SoonReady.SurveyManagement.V1.DomainConcepts.CheckboxQuestionResponse do
  # TODO: Rename for folder to domain concepts
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :question_id, :uuid, allow_nil?: false, public?: true
    attribute :responses, {:array, :ci_string}, public?: true
  end
end
