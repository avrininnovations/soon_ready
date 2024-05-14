defmodule SoonReady.SurveyManagement.ValueObjects.Survey.LongAnswerQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :prompt, :ci_string, allow_nil?: false
  end
end
