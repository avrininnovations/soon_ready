defmodule SoonReady.QuantifyNeeds.Survey.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReady.QuantifyNeeds.Survey.Setup.Registry
  end
end
