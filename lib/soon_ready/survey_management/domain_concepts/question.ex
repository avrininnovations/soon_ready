# defmodule SoonReady.SurveyManagement.DomainConcepts.Question do
#   alias SoonReady.SurveyManagement.DomainConcepts.{
#     ShortAnswerQuestion,
#     ParagraphQuestion,
#     MultipleChoiceQuestion,
#     CheckboxQuestion,
#   }
#   alias SoonReady.SurveyManagement.DomainConcepts.{MultipleChoiceQuestionGroup, ShortAnswerQuestionGroup}

#   use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
#     {ShortAnswerQuestion, [type: ShortAnswerQuestion, tag: :type, tag_value: "short_answer_question"]},
#     {ParagraphQuestion, [type: ParagraphQuestion, tag: :type, tag_value: "paragraph_question"]},
#     {MultipleChoiceQuestion, [type: MultipleChoiceQuestion, tag: :type, tag_value: "multiple_choice_question"]},
#     {CheckboxQuestion, [type: CheckboxQuestion, tag: :type, tag_value: "checkbox_question"]},

#     {ShortAnswerQuestionGroup, [type: ShortAnswerQuestionGroup, tag: :type, tag_value: "short_answer_question_group"]},
#     {MultipleChoiceQuestionGroup, [type: MultipleChoiceQuestionGroup, tag: :type, tag_value: "multiple_choice_question_group"]},
#   ]]
# end
