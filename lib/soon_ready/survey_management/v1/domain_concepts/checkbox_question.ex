defmodule SoonReady.SurveyManagement.V1.DomainConcepts.CheckboxQuestion do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.V1.DomainConcepts.Option

  attributes do
    uuid_primary_key :id, public?: true
    attribute :prompt, :ci_string, allow_nil?: false, public?: true
    attribute :options, {:array, Option}, allow_nil?: false, public?: true, constraints: [min_length: 2]
    attribute :correct_answer_criteria, :atom, constraints: [one_of: [:not_applicable, :any_correct_option, :all_correct_options]], default: :not_applicable, allow_nil?: false, public?: true
    attribute :required?, :boolean, allow_nil?: false, default: true
  end

  validations do
    # TODO: All options are of the same type
    # TODO: :not_applicable is for raw strings
    # TODO: one of the others for option with correct value
  end
end
