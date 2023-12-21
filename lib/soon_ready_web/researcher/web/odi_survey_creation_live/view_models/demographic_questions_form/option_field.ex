defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicQuestionsForm.OptionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false
  end
end
