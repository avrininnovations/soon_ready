defmodule SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.ShortAnswerQuestion

  attributes do
    uuid_primary_key :id, public?: true
    attribute :questions, {:array, ShortAnswerQuestion}, allow_nil?: false, public?: true, constraints: [min_length: 2]
  end
end
