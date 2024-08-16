defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Trigger do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.V1.DomainConcepts.{Question, PageActions}

  attributes do
    attribute :name, :atom, allow_nil?: false, public?: true
    attribute :id, :uuid, allow_nil?: false, public?: true
  end
end
