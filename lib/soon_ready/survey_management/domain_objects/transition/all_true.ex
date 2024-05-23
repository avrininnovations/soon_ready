defmodule SoonReady.SurveyManagement.DomainObjects.Transition.AllTrue do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.Transition.Condition

  attributes do
    attribute :conditions, {:array, Condition}, allow_nil?: false, constraints: [min_length: 1]
  end
end
