# defmodule SoonReady.SurveyManagement.DomainConcepts.MultipleChoiceQuestion do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.SurveyManagement.DomainConcepts.Option

#   attributes do
#     attribute :id, :uuid, primary_key?: true, allow_nil?: false, default: &Ash.UUID.generate/0
#     attribute :prompt, :ci_string, allow_nil?: false
#     attribute :options, {:array, Option}, allow_nil?: false, constraints: [min_length: 2]
#   end

#   validations do
#     # TODO: All options are of the same type
#   end
# end
