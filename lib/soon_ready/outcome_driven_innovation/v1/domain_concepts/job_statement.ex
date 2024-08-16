defmodule SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.JobStatement do
  # TODO/MAYBE: Add check to ensure match with the ODI job step name pattern
  use Ash.Type.NewType, subtype_of: :string
end
