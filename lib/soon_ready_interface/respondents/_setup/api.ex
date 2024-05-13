defmodule SoonReadyInterface.Respondents.Setup.Api do
  use Ash.Api

  resources do
    resource SoonReadyInterface.Respondents.ReadModels.Survey
    resource SoonReadyInterface.Respondents.ReadModels.ResearcherCache
  end

end
