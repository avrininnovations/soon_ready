defmodule SoonReady.SurveyManagement.ValueObjects.JobStepRating do
  # TODO: Change to GroupQuestionResponse
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.DesiredOutcomeRating

  attributes do
    attribute :name, :ci_string, allow_nil?: false
    attribute :desired_outcomes, {:array, DesiredOutcomeRating}, allow_nil?: false, constraints: [min_length: 1]
  end
end
