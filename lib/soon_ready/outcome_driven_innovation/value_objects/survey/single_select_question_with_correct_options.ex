defmodule SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.SingleSelectQuestionWithCorrectOptions do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias __MODULE__.Option
  alias __MODULE__.Validations.AtLeastOneOptionIsCorrect

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, Option}, allow_nil?: false, constraints: [min_length: 2]
  end

  validations do
    validate AtLeastOneOptionIsCorrect
  end
end
