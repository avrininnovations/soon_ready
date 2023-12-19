defmodule SoonReady.SurveyManagement.DomainConcepts.JobStep do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.SurveyManagement.DomainConcepts.{
    JobName,
    DesiredOutcome
  }

  attributes do
    attribute :name, JobName, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcome}, allow_nil?: false, constraints: [min_length: 1]
  end
end
