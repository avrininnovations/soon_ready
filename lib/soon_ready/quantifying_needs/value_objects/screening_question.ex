defmodule SoonReady.QuantifyingNeeds.ValueObjects.ScreeningQuestion do
  # TODO: Replace value objects with fragments?
  # and let every command/event have its own child/embed resource?
  # Events especially as it might make obvious when changes happen

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
