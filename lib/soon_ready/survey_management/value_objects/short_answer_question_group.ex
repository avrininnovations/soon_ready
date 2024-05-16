defmodule SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.ShortAnswerQuestion

  attributes do
    uuid_primary_key :id
    attribute :questions, {:array, ShortAnswerQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end
end
