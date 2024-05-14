defmodule SoonReady.SurveyManagement.ValueObjects.SimpleResponse do
  alias SoonReady.SurveyManagement.ValueObjects.{
    SingleValueResponse,
    MultiValueResponse,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SingleValueResponse, [type: SingleValueResponse, tag: :type, tag_value: "single_value_response"]},
    {MultiValueResponse, [type: MultiValueResponse, tag: :type, tag_value: "multi_value_response"]},
  ]]
end
