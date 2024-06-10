defmodule SoonReady.SurveyManagement.DomainConcepts.Trigger do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.DomainConcepts.{Question, PageActions}

  attributes do
    attribute :event_name, :atom, allow_nil?: false
    attribute :event_id, :uuid, allow_nil?: false
  end
end
