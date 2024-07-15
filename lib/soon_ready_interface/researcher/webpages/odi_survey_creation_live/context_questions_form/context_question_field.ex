defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.ContextQuestionField do
  alias SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm.{
    MultipleChoiceQuestion,
    CheckboxQuestion,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {MultipleChoiceQuestion, [type: MultipleChoiceQuestion, tag: :type, tag_value: "multiple_choice_question"]},
    {CheckboxQuestion, [type: CheckboxQuestion, tag: :type, tag_value: "checkbox_question"]},
  ]]
end
