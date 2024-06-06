defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.Question do
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel.{
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    ParagraphQuestion,
    MultipleChoiceQuestionGroup,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {ShortAnswerQuestion, [type: ShortAnswerQuestion, tag: :type, tag_value: "short_answer_question"]},
    {MultipleChoiceQuestion, [type: MultipleChoiceQuestion, tag: :type, tag_value: "multiple_choice_question"]},
    {ParagraphQuestion, [type: ParagraphQuestion, tag: :type, tag_value: "paragraph_question"]},
    {MultipleChoiceQuestionGroup, [type: MultipleChoiceQuestionGroup, tag: :type, tag_value: "multiple_choice_question_group"]},
  ]]
end
