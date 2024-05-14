defmodule SoonReady.SurveyManagement.ValueObjects.Response do
  alias SoonReady.SurveyManagement.ValueObjects.{
    SingleValueResponse,
    MultiValueResponse,
  }
  alias SoonReady.SurveyManagement.ValueObjects.QuestionGroupResponse

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SingleValueResponse, [type: SingleValueResponse, tag: :type, tag_value: "single_value_response"]},
    {MultiValueResponse, [type: MultiValueResponse, tag: :type, tag_value: "multi_value_response"]},

    {QuestionGroupResponse, [type: QuestionGroupResponse, tag: :type, tag_value: "question_group_response"]},
  ]]
end
