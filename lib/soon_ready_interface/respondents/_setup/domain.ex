defmodule SoonReadyInterface.Respondents.Setup.Domain do
  use Ash.Domain

  resources do
    resource SoonReadyInterface.Respondents.ReadModels.Survey

    resource SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel
  end

end
