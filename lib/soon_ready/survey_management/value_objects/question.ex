defmodule SoonReady.SurveyManagement.ValueObjects.Question do
  alias SoonReady.SurveyManagement.ValueObjects.Survey.{SingleSelectQuestion, MultiSelectQuestion}

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SingleSelectQuestion, [type: SingleSelectQuestion, tag: :type, tag_value: "single_select_option"]},
    {MultiSelectQuestion, [type: MultiSelectQuestion, tag: :type, tag_value: "multi_select_option"]},
  ]]
end
