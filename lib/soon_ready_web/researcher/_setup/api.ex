defmodule SoonReadyWeb.Researcher.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReadyWeb.Researcher.Setup.Registry
  end
end
