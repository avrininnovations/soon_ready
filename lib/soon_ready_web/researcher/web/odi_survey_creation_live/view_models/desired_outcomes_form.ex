defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.SurveyManagement.DomainConcepts.JobStep

  attributes do
    attribute :job_steps, {:array, JobStep}, allow_nil?: false, constraints: [min_length: 1]
  end
end
