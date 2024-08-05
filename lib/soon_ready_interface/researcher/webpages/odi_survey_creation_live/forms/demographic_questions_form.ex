defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DemographicQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.DemographicQuestionField

  attributes do
    attribute :demographic_questions, {:array, DemographicQuestionField}, allow_nil?: false, public?: true
  end
end
