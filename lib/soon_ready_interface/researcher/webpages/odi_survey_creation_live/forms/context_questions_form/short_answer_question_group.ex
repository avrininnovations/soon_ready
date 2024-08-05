defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.QuestionField

  attributes do
    attribute :group_prompt, :string, allow_nil?: false, public?: true
    attribute :add_button_label, :string, allow_nil?: false, public?: true
    attribute :questions, {:array, QuestionField}, allow_nil?: false, public?: true, constraints: [min_length: 2]
  end
end
