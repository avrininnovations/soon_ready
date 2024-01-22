defmodule SoonReady.QuantifyingNeeds.Survey.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReady.QuantifyingNeeds.Survey.Setup.Registry
  end
end
