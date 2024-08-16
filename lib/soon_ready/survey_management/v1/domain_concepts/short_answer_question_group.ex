defmodule SoonReady.SurveyManagement.V1.DomainConcepts.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias __MODULE__.Question

  attributes do
    uuid_primary_key :id, public?: true
    attribute :group_prompt, :string, allow_nil?: false, public?: true
    attribute :questions, {:array, Question}, allow_nil?: false, public?: true, constraints: [min_length: 1]
    attribute :add_button_label, :string, allow_nil?: false, public?: true
  end
end
