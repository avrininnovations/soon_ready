defmodule SoonReady.SurveyManagement.V1.DomainConcepts.SurveyPage do
  # TODO: Rename to Page
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.V1.DomainConcepts.{Question, Transition}

  attributes do
    # TODO: Add restrictions that set and govern what question types are allowed on a page
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true
    attribute :title, :ci_string, allow_nil?: false, public?: true
    attribute :description, :ci_string, public?: true
    attribute :questions, {:array, Question}, public?: true, default: []
    attribute :transitions, {:array, Transition}, public?: true
  end
end
