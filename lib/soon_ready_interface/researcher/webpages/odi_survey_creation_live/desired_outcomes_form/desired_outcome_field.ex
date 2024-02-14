defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm.DesiredOutcomeField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.QuantifyingNeeds.Survey.DomainDataTypes.DesiredOutcome

  attributes do
    attribute :value, DesiredOutcome, allow_nil?: false
  end
end
