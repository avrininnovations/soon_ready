defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.DesiredOutcomesForm do
  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.JobStepField

  attributes do
    attribute :job_steps, {:array, JobStepField}, allow_nil?: false, public?: true, constraints: [min_length: 1]
  end
end
