defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.ContextQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.ContextQuestionField

  attributes do
    attribute :context_questions, {:array, ContextQuestionField}, allow_nil?: false
  end
end
