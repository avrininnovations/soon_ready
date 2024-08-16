# defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.Survey.Participant do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   attributes do
#     attribute :nickname, :string, allow_nil?: false
#     # MAYBE: Create custom types for email and phone_number
#     attribute :email, :string, allow_nil?: false
#     attribute :phone_number, :string, allow_nil?: false
#   end

#   actions do
#     defaults [:create, :read]
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :create
#   end
# end
