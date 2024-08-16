defmodule SoonReady.SurveyManagement.V1.DomainConcepts.MultipleChoiceQuestionGroupResponses do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias __MODULE__.SingleResponse

  attributes do
    attribute :group_id, :uuid, allow_nil?: false, public?: true
    attribute :responses, {:array, SingleResponse}, allow_nil?: false, public?: true
  end
end
