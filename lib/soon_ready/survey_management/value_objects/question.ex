defmodule SoonReady.SurveyManagement.ValueObjects.Question do
  alias SoonReady.SurveyManagement.ValueObjects.{
    ShortAnswerQuestion,
    ParagraphQuestion,
    MultipleChoiceQuestion,
    CheckboxQuestion,
  }
  alias SoonReady.SurveyManagement.ValueObjects.QuestionGroup

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    # TODO: Should basic question have tag or just delegate?
    {ShortAnswerQuestion, [type: ShortAnswerQuestion, tag: :type, tag_value: "short_answer_question"]},
    {ParagraphQuestion, [type: ParagraphQuestion, tag: :type, tag_value: "paragraph_question"]},
    {MultipleChoiceQuestion, [type: MultipleChoiceQuestion, tag: :type, tag_value: "multiple_choice_question"]},
    {CheckboxQuestion, [type: CheckboxQuestion, tag: :type, tag_value: "checkbox_question"]},

    {QuestionGroup, [type: QuestionGroup, tag: :type, tag_value: "question_group"]},
  ]]
end
