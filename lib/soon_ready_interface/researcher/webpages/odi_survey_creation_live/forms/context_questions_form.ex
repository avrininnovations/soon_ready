defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.{ContextQuestionField, MultipleChoiceQuestion, CheckboxQuestion, ShortAnswerQuestionGroup}

  attributes do
    attribute :context_questions, {:array, ContextQuestionField}, allow_nil?: false, public?: true
  end
end
