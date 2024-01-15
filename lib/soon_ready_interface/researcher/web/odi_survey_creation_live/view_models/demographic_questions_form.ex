defmodule SoonReadyInterface.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.DemographicQuestionField

  attributes do
    attribute :demographic_questions, {:array, DemographicQuestionField}, allow_nil?: false
  end
end
