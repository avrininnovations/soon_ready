# defmodule SoonReady.SurveyManagement.Events.SurveyPublishedV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.SurveyManagement.DomainConcepts.Trigger

#   attributes do
#     attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :trigger, Trigger
#   end

#   actions do
#     create :new
#   end

#   code_interface do
#     define_for SoonReady.SurveyManagement
#     define :new
#   end
# end
