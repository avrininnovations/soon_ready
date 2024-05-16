defmodule SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    uuid_primary_key :id
    attribute :prompt, :ci_string, allow_nil?: false
  end
end
