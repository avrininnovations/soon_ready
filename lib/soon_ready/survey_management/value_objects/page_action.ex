defmodule SoonReady.SurveyManagement.ValueObjects.PageAction do
  alias __MODULE__.{SubmitForm, ChangePage}

  use Ash.Type.NewType, subtype_of: :union, constraints: [types: [
    {SubmitForm, [type: SubmitForm]},
    {ChangePage, [type: ChangePage, tag: :type, tag_value: "change_page"]},
  ]]
end
