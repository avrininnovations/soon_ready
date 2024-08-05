defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DomainConcepts.ScreeningQuestionsForm.ScreeningQuestionField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DomainConcepts.ScreeningQuestionsForm.OptionField

  attributes do
    attribute :prompt, :string, allow_nil?: false, public?: true
    attribute :options, {:array, OptionField}, allow_nil?: false, public?: true, constraints: [min_length: 2]
  end
end
