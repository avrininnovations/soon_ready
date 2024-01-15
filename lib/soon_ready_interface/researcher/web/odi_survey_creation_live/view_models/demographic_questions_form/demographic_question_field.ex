defmodule SoonReadyInterface.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicQuestionsForm.DemographicQuestionField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Researcher.Web.OdiSurveyCreationLive.ViewModels.DemographicQuestionsForm.OptionField

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, OptionField}, allow_nil?: false, constraints: [min_length: 2]
  end
end
