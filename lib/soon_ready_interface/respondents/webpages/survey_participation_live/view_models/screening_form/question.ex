defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ScreeningForm.Question do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ScreeningForm.Option

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, Option}, allow_nil?: false
    attribute :response, :string, allow_nil?: true
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create
  end
end
