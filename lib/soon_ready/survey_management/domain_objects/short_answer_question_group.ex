defmodule SoonReady.SurveyManagement.DomainObjects.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.ShortAnswerQuestion

  attributes do
    uuid_primary_key :id
    attribute :questions, {:array, ShortAnswerQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end
end
