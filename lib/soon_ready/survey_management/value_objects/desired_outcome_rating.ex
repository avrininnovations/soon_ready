defmodule SoonReady.SurveyManagement.ValueObjects.DesiredOutcomeRating do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :name, :ci_string, allow_nil?: false
    attribute :importance, :ci_string, allow_nil?: false
    attribute :satisfaction, :ci_string, allow_nil?: false
  end
end
