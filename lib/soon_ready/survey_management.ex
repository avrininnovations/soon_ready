# defmodule SoonReady.SurveyManagement do
#   use Ash.Api

#   alias SoonReady.SurveyManagement.Commands.{CreateSurvey, PublishSurvey, SubmitSurveyResponse}
#   alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey

#   resources do

#   end

#   authorization do
#     authorize :by_default
#   end

#   defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
#   defdelegate publish_survey(params), to: PublishSurvey, as: :dispatch
#   defdelegate submit_response(params), to: SubmitSurveyResponse, as: :dispatch
# end
