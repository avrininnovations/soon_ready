defmodule SoonReady.SurveyManagement.ValueObjects.Response do
  alias SoonReady.SurveyManagement.ValueObjects.{
    ShortAnswerQuestionResponse,
    ParagraphQuestionResponse,
    MultipleChoiceQuestionResponse,
    CheckboxQuestionResponse,
    
    ShortAnswerQuestionGroupResponses,
    MultipleChoiceQuestionGroupResponses,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestionResponse, [type: ShortAnswerQuestionResponse, tag: :type, tag_value: "short_answer_question_response"]},
    {ParagraphQuestionResponse, [type: ParagraphQuestionResponse, tag: :type, tag_value: "paragraph_question_response"]},
    {MultipleChoiceQuestionResponse, [type: MultipleChoiceQuestionResponse, tag: :type, tag_value: "multiple_choice_question_response"]},
    {CheckboxQuestionResponse, [type: CheckboxQuestionResponse, tag: :type, tag_value: "checkbox_question_response"]},

    {ShortAnswerQuestionGroupResponses, [type: ShortAnswerQuestionGroupResponses, tag: :type, tag_value: "short_answer_question_group_responses"]},
    {MultipleChoiceQuestionGroupResponses, [type: MultipleChoiceQuestionGroupResponses, tag: :type, tag_value: "multiple_choice_question_group_responses"]},
  ]]
end
