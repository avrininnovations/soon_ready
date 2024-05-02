defmodule SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.QuestionResponse do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :response, :string, allow_nil?: false
  end
end
