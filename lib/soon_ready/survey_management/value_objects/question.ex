defmodule SoonReady.SurveyManagement.ValueObjects.Question do
  alias SoonReady.SurveyManagement.ValueObjects.Survey.{
    ShortAnswerQuestion,
    LongAnswerQuestion,
    SingleSelectQuestion,
    MultiSelectQuestion
  }
  
  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestion, [type: ShortAnswerQuestion, tag: :type, tag_value: "short_answer_question"]},
    {LongAnswerQuestion, [type: LongAnswerQuestion, tag: :type, tag_value: "long_answer_question"]},
    # TODO: ..._option
    {SingleSelectQuestion, [type: SingleSelectQuestion, tag: :type, tag_value: "single_select_option"]},
    {MultiSelectQuestion, [type: MultiSelectQuestion, tag: :type, tag_value: "multi_select_option"]},
  ]]
end
