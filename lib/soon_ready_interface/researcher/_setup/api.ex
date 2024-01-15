defmodule SoonReadyInterface.Researcher.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReadyInterface.Researcher.Setup.Registry
  end
end
