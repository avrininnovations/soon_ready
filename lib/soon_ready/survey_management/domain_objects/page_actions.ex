defmodule SoonReady.SurveyManagement.DomainObjects.PageActions do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.PageAction

  attributes do
    attribute :correct_response_action, PageAction, allow_nil?: false
    attribute :incorrect_response_action, PageAction, allow_nil?: false
    attribute :correctness_criteria, :atom, allow_nil?: false, constraints: [one_of: [:all_questions_are_correctly_answered, :any_question_is_correctly_answered]], default: :all_questions_are_correctly_answered
  end
end
