defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.OutcomeStatement do
  # TODO/MAYBE: Add check to ensure match with the ODI desired outcome name pattern
  use Ash.Type.NewType, subtype_of: :string
end
