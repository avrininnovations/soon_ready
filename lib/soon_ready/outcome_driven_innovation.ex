defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Domain

  resources do
    resource SoonReady.OutcomeDrivenInnovation.V1.Events.ProjectCreated
    resource SoonReady.OutcomeDrivenInnovation.V1.Events.MarketDefined
    resource SoonReady.OutcomeDrivenInnovation.V1.Events.NeedsDefined
  end

  authorization do
    authorize :by_default
  end
end
