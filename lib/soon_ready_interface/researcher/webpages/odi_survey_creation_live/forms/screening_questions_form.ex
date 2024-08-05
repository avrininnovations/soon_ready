defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ScreeningQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.ScreeningQuestionField

  attributes do
    attribute :screening_questions, {:array, ScreeningQuestionField}, allow_nil?: false, public?: true
  end
end
