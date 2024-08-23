defmodule SoonReadyInterface.Researcher do
  use Ash.Domain

  resources do
    resource SoonReadyInterface.Researcher.Commands.CreateSurvey do
      define :create_survey, action: :dispatch
    end

    resource SoonReadyInterface.Aggregates.Survey
  end
end
