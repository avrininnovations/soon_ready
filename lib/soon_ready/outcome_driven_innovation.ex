defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Domain

  resources do
    resource SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.ProjectCreated
    resource SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.MarketDefined
    resource SoonReady.OutcomeDrivenInnovation.V1.DomainEvents.NeedsDefined
  end

  authorization do
    authorize :by_default
  end
end
