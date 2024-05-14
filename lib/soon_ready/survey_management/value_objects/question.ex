defmodule SoonReady.SurveyManagement.ValueObjects.Question do
  alias SoonReady.SurveyManagement.ValueObjects.Survey.{SingleSelectQuestion, SingleSelectQuestionWithCorrectOptions}

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SingleSelectQuestion, [type: SingleSelectQuestion]},
  ]]
end
