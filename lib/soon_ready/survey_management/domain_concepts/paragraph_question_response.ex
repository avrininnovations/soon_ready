# defmodule SoonReady.SurveyManagement.DomainConcepts.ParagraphQuestionResponse do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   # TODO: Check nility of all response types
#   attributes do
#     attribute :question_id, :uuid, allow_nil?: false
#     attribute :response, :ci_string
#   end
# end
