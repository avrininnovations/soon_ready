defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.DesiredOutcomesForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.JobStepField

  attributes do
    attribute :job_steps, {:array, JobStepField}, allow_nil?: false, constraints: [min_length: 1]
  end
end
