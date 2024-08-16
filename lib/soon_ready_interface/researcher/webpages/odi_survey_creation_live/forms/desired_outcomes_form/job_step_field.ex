defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DesiredOutcomesForm.JobStepField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.OutcomeDrivenInnovation.V1.DomainConcepts.JobStatement
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DesiredOutcomesForm.DesiredOutcomeField

  attributes do
    attribute :name, JobStatement, allow_nil?: false, public?: true
    attribute :desired_outcomes, {:array, DesiredOutcomeField}, allow_nil?: false, public?: true, constraints: [min_length: 1]
  end
end
