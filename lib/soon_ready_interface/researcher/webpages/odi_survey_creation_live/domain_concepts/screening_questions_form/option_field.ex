defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DomainConcepts.ScreeningQuestionsForm.OptionField do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :value, :string, allow_nil?: false, public?: true
    attribute :is_correct_option, :boolean, allow_nil?: false, public?: true
  end
end
