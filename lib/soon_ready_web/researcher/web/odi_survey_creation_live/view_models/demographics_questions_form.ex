defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicsQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.DemographicsQuestionField

  attributes do
    attribute :demographics_questions, {:array, DemographicsQuestionField}, allow_nil?: false
  end
end
