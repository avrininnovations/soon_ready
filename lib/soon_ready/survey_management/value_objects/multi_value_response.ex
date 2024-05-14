defmodule SoonReady.SurveyManagement.ValueObjects.MultiValueResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :prompt, :ci_string, allow_nil?: false
    attribute :response, {:array, :ci_string}, allow_nil?: false
  end
end
