# defmodule SoonReady.SurveyManagement.DomainConcepts.MultipleChoiceQuestionGroupResponses do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias __MODULE__.SingleResponse

#   attributes do
#     attribute :group_id, :uuid, allow_nil?: false
#     attribute :responses, {:array, SingleResponse}, allow_nil?: false
#   end
# end
