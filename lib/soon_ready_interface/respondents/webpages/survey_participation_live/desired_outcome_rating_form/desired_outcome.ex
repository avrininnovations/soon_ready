defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.DesiredOutcomeRatingForm.DesiredOutcome do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :name, :string, allow_nil?: false
    # TODO: Change these to enums?
    attribute :importance, :string
    attribute :satisfaction, :string
  end

  actions do
    defaults [:create, :read, :destroy]

    update :update do
      primary? true

      validate present(:importance)
      validate present(:satisfaction)
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api
    define :create
  end
end
