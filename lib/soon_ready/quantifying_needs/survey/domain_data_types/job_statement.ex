defmodule SoonReady.QuantifyingNeeds.Survey.DomainDataTypes.JobStatement do
  # TODO: Add check to ensure match with the ODI job step name pattern
  use Ash.Type.NewType, subtype_of: :string
end
