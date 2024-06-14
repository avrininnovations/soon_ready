# defmodule SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationSucceededV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   attributes do
#     attribute :researcher_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :user_id, :uuid, allow_nil?: false
#   end

#   actions do
#     defaults [:create, :read]
#   end

#   code_interface do
#     define_for SoonReady.IdentityAndAccessManagement
#     define :create
#   end
# end
