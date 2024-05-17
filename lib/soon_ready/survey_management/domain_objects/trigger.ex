defmodule SoonReady.SurveyManagement.DomainObjects.Trigger do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.DomainObjects.{Question, PageActions}

  attributes do
    attribute :event_name, :atom, allow_nil?: false
    attribute :event_id, :uuid, allow_nil?: false
  end
end
