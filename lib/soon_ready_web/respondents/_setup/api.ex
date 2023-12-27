defmodule SoonReadyWeb.Respondents.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReadyWeb.Respondents.Setup.Registry
  end
end
