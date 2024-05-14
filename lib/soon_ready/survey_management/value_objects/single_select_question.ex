defmodule SoonReady.SurveyManagement.ValueObjects.SingleSelectQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.Option

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, Option}, allow_nil?: false, constraints: [min_length: 2]
  end

  validations do
    # TODO: All options are of the same type
  end
end
