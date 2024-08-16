defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Transition.AnyTrue do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.V1.DomainConcepts.Transition.Condition

  attributes do
    attribute :conditions, {:array, Condition}, allow_nil?: false, public?: true, constraints: [min_length: 1]
  end
end
