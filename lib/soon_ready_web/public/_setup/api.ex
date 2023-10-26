defmodule SoonReadyWeb.Public.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReadyWeb.Public.Setup.Registry
  end
end
