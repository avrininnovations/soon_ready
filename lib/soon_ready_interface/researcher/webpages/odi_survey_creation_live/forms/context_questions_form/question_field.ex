defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.ContextQuestionsForm.QuestionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :required?, :boolean, allow_nil?: false, public?: true
  end
end
