defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Transition.ResponseEquals do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :question_id, :uuid, allow_nil?: false, public?: true
    attribute :value, :ci_string, allow_nil?: false, public?: true
  end
end
