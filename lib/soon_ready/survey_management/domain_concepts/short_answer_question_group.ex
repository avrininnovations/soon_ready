defmodule SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestion

  attributes do
    uuid_primary_key :id
    attribute :questions, {:array, ShortAnswerQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end
end
