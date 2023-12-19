defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.JobStepField do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm.{
    JobStepConcept,
    DesiredOutcomeField
  }

  attributes do
    attribute :name, JobStepConcept, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeField}, allow_nil?: false, constraints: [min_length: 1]
  end
end
