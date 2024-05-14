defmodule SoonReady.SurveyManagement.ValueObjects.SurveyPage do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]
  alias SoonReady.SurveyManagement.ValueObjects.Question

  attributes do
    # TODO: Add restrictions that set and govern what question types are allowed on a page
    attribute :questions, {:array, Question}, allow_nil?: false
  end
end
