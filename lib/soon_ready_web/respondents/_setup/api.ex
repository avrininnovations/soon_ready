defmodule SoonReadyWeb.Respondents.Setup.Api do
  use Ash.Api

  resources do
    resource SoonReadyWeb.Respondents.ReadModels.ActiveOdiSurveys
  end
end
