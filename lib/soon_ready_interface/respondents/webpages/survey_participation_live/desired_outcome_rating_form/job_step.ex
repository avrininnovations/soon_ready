defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.DesiredOutcomeRatingForm.JobStep do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.DesiredOutcomeRatingForm.DesiredOutcome

  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcome}, allow_nil?: false
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api
    define :create
  end
end
