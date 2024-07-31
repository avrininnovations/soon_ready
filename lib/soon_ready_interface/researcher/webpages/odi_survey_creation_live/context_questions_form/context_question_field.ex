defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.ContextQuestionField do
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.{
    MultipleChoiceQuestion,
    CheckboxQuestion,
    ShortAnswerQuestionGroup,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {MultipleChoiceQuestion, [type: MultipleChoiceQuestion, tag: :type, tag_value: "multiple_choice_question"]},
    {CheckboxQuestion, [type: CheckboxQuestion, tag: :type, tag_value: "checkbox_question"]},
    {ShortAnswerQuestionGroup, [type: ShortAnswerQuestionGroup, tag: :type, tag_value: "short_answer_question_group"]},
  ]]
end
