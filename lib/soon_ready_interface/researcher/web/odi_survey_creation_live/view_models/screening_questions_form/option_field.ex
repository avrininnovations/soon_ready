defmodule SoonReadyInterface.Researcher.Web.OdiSurveyCreationLive.ViewModels.ScreeningQuestionsForm.OptionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false
    attribute :is_correct_option, :boolean, allow_nil?: false
  end
end
