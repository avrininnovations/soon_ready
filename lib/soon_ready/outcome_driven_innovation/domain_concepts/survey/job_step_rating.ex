defmodule SoonReady.OutcomeDrivenInnovation.DomainConcepts.Survey.JobStepRating do
  # TODO: Change to GroupQuestionResponse
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.OutcomeDrivenInnovation.DomainConcepts.Survey.DesiredOutcomeRating

  attributes do
    attribute :name, :string, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeRating}, allow_nil?: false, constraints: [min_length: 1]
  end
end
