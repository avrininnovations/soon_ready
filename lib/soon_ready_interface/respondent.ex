defmodule SoonReadyInterface.Respondent do
  use Ash.Domain

  resources do
    resource SoonReadyInterface.Respondent.Commands.SubmitSurveyResponse do
      define :submit_survey_response, action: :dispatch
    end
    resource SoonReadyInterface.Respondent.Commands.Aggregate
    resource SoonReadyInterface.Respondent.ReadModels.Survey
    resource SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.FormViewModel
  end

end
