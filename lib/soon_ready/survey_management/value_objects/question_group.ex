defmodule SoonReady.SurveyManagement.ValueObjects.QuestionGroup do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.ValueObjects.BasicQuestion

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :questions, {:array, BasicQuestion}, allow_nil?: false, constraints: [min_length: 2]
  end

  validations do
    # TODO: All questions are of the same type?
  end
end
