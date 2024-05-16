defmodule SoonReady.SurveyManagement.ValueObjects.Response do
  alias SoonReady.SurveyManagement.ValueObjects.{
    ShortAnswerQuestionResponse,
    ParagraphQuestionResponse,
    MultipleChoiceQuestionResponse,


    MultiValueResponse,
  }
  alias SoonReady.SurveyManagement.ValueObjects.QuestionGroupResponse

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestionResponse, [type: ShortAnswerQuestionResponse, tag: :type, tag_value: "short_answer_question_response"]},
    {ParagraphQuestionResponse, [type: ParagraphQuestionResponse, tag: :type, tag_value: "paragraph_question_response"]},
    {MultipleChoiceQuestionResponse, [type: MultipleChoiceQuestionResponse, tag: :type, tag_value: "multiple_choice_question_response"]},


    {MultiValueResponse, [type: MultiValueResponse, tag: :type, tag_value: "multi_value_response"]},

    {QuestionGroupResponse, [type: QuestionGroupResponse, tag: :type, tag_value: "question_group_response"]},
  ]]
end
