defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.JobStepField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.QuantifyingNeeds.Survey.DomainDataTypes.JobStep
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.DesiredOutcomeField

  attributes do
    attribute :name, JobStep, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeField}, allow_nil?: false, constraints: [min_length: 1]
  end
end
