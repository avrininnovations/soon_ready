# defmodule SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestionResponse do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   attributes do
#     attribute :question_id, :uuid, allow_nil?: false
#     attribute :response, :ci_string
#   end
# end
