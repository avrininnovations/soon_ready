defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DesiredOutcomesForm.DesiredOutcomeField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.OutcomeStatement

  attributes do
    attribute :value, OutcomeStatement, allow_nil?: false, public?: true
  end
end
