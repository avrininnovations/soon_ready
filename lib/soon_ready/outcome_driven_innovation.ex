defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Domain

  resources do
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.ProjectCreatedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.MarketDefinedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.NeedsDefinedV1
  end

  authorization do
    authorize :by_default
  end
end
