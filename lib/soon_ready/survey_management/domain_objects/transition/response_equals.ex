defmodule SoonReady.SurveyManagement.DomainObjects.Transition.ResponseEquals do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :question_id, :uuid, allow_nil?: false
    attribute :value, :ci_string, allow_nil?: false
  end
end
