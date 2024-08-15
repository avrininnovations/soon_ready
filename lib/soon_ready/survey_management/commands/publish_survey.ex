# defmodule SoonReady.SurveyManagement.Commands.PublishSurvey do
#   use Ash.Resource, domain: SoonReady.SurveyManagement

#   alias SoonReady.Application

#   attributes do
#     attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
#   end

#   actions do
#     default_accept [:survey_id]

#     create :dispatch do
#       change fn changeset, context ->
#         Ash.Changeset.after_action(changeset, fn changeset, command ->
#           with :ok <- Application.dispatch(command) do
#             {:ok, command}
#           end
#         end)
#       end
#     end
#   end

#   code_interface do
#     define :dispatch
#   end
# end
