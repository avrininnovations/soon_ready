defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.DesiredOutcomeField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.SurveyManagement.DomainDataTypes.DesiredOutcome

  attributes do
    attribute :value, DesiredOutcome, allow_nil?: false
  end
end
