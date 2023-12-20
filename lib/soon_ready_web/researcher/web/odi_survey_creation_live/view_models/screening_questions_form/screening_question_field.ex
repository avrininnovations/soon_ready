defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.ScreeningQuestionsForm.ScreeningQuestionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :prompt, :string, allow_nil?: false
  end
end
