defmodule SoonReady.QuantifyNeeds.Survey.ValueObjects.ScreeningQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias __MODULE__.Option

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, Option}, allow_nil?: false, constraints: [min_length: 2]
  end

  validations do
    # TODO: validate that at least one option is marked as the correct answer
  end
end
