defmodule SoonReady.SurveyManagement.DomainConcepts.Transition do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.Transition.Condition

  attributes do
    attribute :condition, Condition, allow_nil?: false, public?: true
    attribute :destination_page_id, :uuid, allow_nil?: false, public?: true
    attribute :submit_response?, :boolean, allow_nil?: false, default: false, public?: true
  end
end
