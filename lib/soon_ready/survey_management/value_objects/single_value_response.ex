defmodule SoonReady.SurveyManagement.ValueObjects.SingleValueResponse do
  # TODO: :prompt vs :label
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  # TODO: Change :string to :ci_string
  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :response, :string, allow_nil?: false
  end
end
