defmodule SoonReady.SurveyManagement.DomainObjects.Option do
  alias SoonReady.SurveyManagement.DomainObjects.OptionWithCorrectFlag

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {:ci_string, [type: :ci_string]},
    {OptionWithCorrectFlag, [type: OptionWithCorrectFlag, tag: :type, tag_value: "option_with_correct_flag"]},
  ]]
end
