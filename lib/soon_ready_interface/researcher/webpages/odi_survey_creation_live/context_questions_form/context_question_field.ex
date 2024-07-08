defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.ContextQuestionField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.OptionField

  attributes do
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :options, {:array, OptionField}, allow_nil?: false, public?: true, constraints: [min_length: 2]
  end
end
