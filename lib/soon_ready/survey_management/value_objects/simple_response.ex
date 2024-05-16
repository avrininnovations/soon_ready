defmodule SoonReady.SurveyManagement.ValueObjects.SimpleResponse do
  alias SoonReady.SurveyManagement.ValueObjects.{
    MultiValueResponse,
  }

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {MultiValueResponse, [type: MultiValueResponse, tag: :type, tag_value: "multi_value_response"]},
  ]]
end
