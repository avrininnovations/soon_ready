defmodule SoonReady.SurveyManagement.DomainObjects.Transition do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.Transition.Condition

  attributes do
    attribute :condition, Condition, allow_nil?: false
    attribute :destination_page_id, :uuid, allow_nil?: false
    attribute :submit_response?, :boolean, allow_nil?: false, default: false
  end
end
