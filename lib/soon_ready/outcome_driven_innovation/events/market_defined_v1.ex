# defmodule SoonReady.OutcomeDrivenInnovation.Events.MarketDefinedV1 do
#   use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

#   alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.Market

#   attributes do
#     attribute :project_id, :uuid, allow_nil?: false, primary_key?: true
#     attribute :market, Market
#   end

#   actions do
#     create :new
#   end

#   code_interface do
#     define_for SoonReady.OutcomeDrivenInnovation
#     define :new
#   end
# end
