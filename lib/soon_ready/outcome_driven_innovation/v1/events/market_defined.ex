defmodule SoonReady.OutcomeDrivenInnovation.V1.Events.MarketDefined do
  use Ash.Resource,
    domain: SoonReady.OutcomeDrivenInnovation,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.Market

  attributes do
    attribute :project_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :market, Market, public?: true
  end

  actions do
    default_accept [
      :project_id,
      :market,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
