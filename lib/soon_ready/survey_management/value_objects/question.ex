defmodule SoonReady.SurveyManagement.ValueObjects.Question do
  alias SoonReady.SurveyManagement.ValueObjects.Survey.{SingleSelectQuestion, SingleSelectQuestionWithCorrectOptions}

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SingleSelectQuestion, [type: SingleSelectQuestion, tag: :type, tag_value: "single_select_question"]},
    {SingleSelectQuestionWithCorrectOptions, [type: SingleSelectQuestionWithCorrectOptions, tag: :type, tag_value: "single_select_question_with_correct_options"]},
  ]]
end
