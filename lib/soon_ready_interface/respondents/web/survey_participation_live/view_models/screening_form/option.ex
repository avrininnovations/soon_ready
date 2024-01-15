defmodule SoonReadyInterface.Respondents.Web.SurveyParticipationLive.ViewModels.ScreeningForm.Option do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false
    attribute :is_correct, :boolean, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create
  end
end
