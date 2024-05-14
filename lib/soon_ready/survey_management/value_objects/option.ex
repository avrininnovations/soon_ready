defmodule SoonReady.SurveyManagement.ValueObjects.Option do
  alias SoonReady.SurveyManagement.ValueObjects.OptionWithCorrectFlag

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {:string, [type: :string]},
    {OptionWithCorrectFlag, [type: OptionWithCorrectFlag, tag: :type, tag_value: "option_with_correct_flag"]},
  ]]
end
