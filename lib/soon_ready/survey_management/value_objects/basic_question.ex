defmodule SoonReady.SurveyManagement.ValueObjects.BasicQuestion do
  alias SoonReady.SurveyManagement.ValueObjects.{
    ShortAnswerQuestion,
    LongAnswerQuestion,
    SingleSelectQuestion,
    MultiSelectQuestion
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestion, [type: ShortAnswerQuestion, tag: :type, tag_value: "short_answer_question"]},
    {LongAnswerQuestion, [type: LongAnswerQuestion, tag: :type, tag_value: "long_answer_question"]},
    {SingleSelectQuestion, [type: SingleSelectQuestion, tag: :type, tag_value: "single_select_question"]},
    {MultiSelectQuestion, [type: MultiSelectQuestion, tag: :type, tag_value: "multi_select_question"]},
  ]]
end
