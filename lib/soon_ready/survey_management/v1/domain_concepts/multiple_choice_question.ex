defmodule SoonReady.SurveyManagement.V1.DomainConcepts.MultipleChoiceQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.V1.DomainConcepts.Option

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false, public?: true, default: &Ash.UUID.generate/0
    attribute :prompt, :ci_string, allow_nil?: false, public?: true
    attribute :options, {:array, Option}, allow_nil?: false, public?: true, constraints: [min_length: 2]
    attribute :required?, :boolean, allow_nil?: false, default: true
  end

  validations do
    # TODO: All options are of the same type
  end
end
