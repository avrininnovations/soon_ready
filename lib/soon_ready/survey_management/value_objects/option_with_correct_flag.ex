defmodule SoonReady.SurveyManagement.ValueObjects.OptionWithCorrectFlag do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :value, :ci_string, allow_nil?: false
    attribute :correct?, :boolean, allow_nil?: false
  end
end
