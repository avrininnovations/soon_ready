defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Transition.Condition do
  alias SoonReady.SurveyManagement.V1.DomainConcepts.Transition.{Always, ResponseEquals, AnyTrue, AllTrue}


  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {Always, [type: Always]},
    {ResponseEquals, [type: ResponseEquals, tag: :type, tag_value: "response_equals"]},
    {AnyTrue, [type: AnyTrue, tag: :type, tag_value: "any_true", init?: false]},
    {AllTrue, [type: AllTrue, tag: :type, tag_value: "all_true", init?: false]},
  ]]
end
