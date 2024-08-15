defmodule SoonReadyInterface.Respondents do
  use Ash.Domain

  resources do
    resource SoonReadyInterface.Respondents.Commands.SubmitSurveyResponse do
      define :submit_response, action: :dispatch
    end
    resource SoonReadyInterface.Respondents.Commands.Handlers.Survey
    resource SoonReadyInterface.Respondents.ReadModels.Survey
    resource SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel
  end

end
