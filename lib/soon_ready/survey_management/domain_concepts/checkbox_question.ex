# defmodule SoonReady.SurveyManagement.DomainConcepts.CheckboxQuestion do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.SurveyManagement.DomainConcepts.Option

#   attributes do
#     uuid_primary_key :id
#     attribute :prompt, :ci_string, allow_nil?: false
#     attribute :options, {:array, Option}, allow_nil?: false, constraints: [min_length: 2]
#     attribute :correct_answer_criteria, :atom, constraints: [one_of: [:not_applicable, :any_correct_option, :all_correct_options]], default: :not_applicable, allow_nil?: false
#   end

#   validations do
#     # TODO: All options are of the same type
#     # TODO: :not_applicable is for raw strings
#     # TODO: one of the others for option with correct value
#   end
# end
