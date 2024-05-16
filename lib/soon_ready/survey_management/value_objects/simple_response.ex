defmodule SoonReady.SurveyManagement.ValueObjects.SimpleResponse do
  alias SoonReady.SurveyManagement.ValueObjects.{
    CheckboxQuestionResponse,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {CheckboxQuestionResponse, [type: CheckboxQuestionResponse, tag: :type, tag_value: "checkbox_question_response"]},
  ]]
end
