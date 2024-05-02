defmodule SoonReady.OutcomeDrivenInnovation.ValueObjects.Survey.OutcomeStatement do
  # MAYBE: Add check to ensure match with the ODI desired outcome name pattern
  use Ash.Type.NewType, subtype_of: :string
end
