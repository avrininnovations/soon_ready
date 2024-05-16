defmodule SoonReady.SurveyManagement.DomainObjects.SurveyPage do
  # TODO: Rename to Page
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.DomainObjects.{Question, PageActions}

  attributes do
    # TODO: Add restrictions that set and govern what question types are allowed on a page
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
    attribute :questions, {:array, Question}, allow_nil?: false
    attribute :actions, PageActions, allow_nil?: false
  end
end
