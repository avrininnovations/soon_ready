defmodule SoonReady.SurveyManagement.DomainObjects.Transition.Condition do
  alias SoonReady.SurveyManagement.DomainObjects.Transition.{Always, ResponseEquals, AnyTrue, AllTrue}


  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {Always, [type: Always]},
    {ResponseEquals, [type: ResponseEquals, tag: :type, tag_value: "response_equals"]},
    {AnyTrue, [type: AnyTrue, tag: :type, tag_value: "any_true"]},
    {AllTrue, [type: AllTrue, tag: :type, tag_value: "all_true"]},
  ]]
end
