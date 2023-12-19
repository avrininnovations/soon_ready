defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.DesiredOutcomeField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.DesiredOutcomeConcept

  attributes do
    attribute :value, DesiredOutcomeConcept, allow_nil?: false
  end
end
