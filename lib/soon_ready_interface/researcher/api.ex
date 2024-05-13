defmodule SoonReadyInterface.Researcher.Api do
  use Ash.Api

  resources do
    resource SoonReadyInterface.Researcher.ReadModels.ResearcherCache
  end
end
