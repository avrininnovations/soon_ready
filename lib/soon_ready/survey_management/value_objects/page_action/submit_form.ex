defmodule SoonReady.SurveyManagement.ValueObjects.PageAction.SubmitForm do
  use Ash.Type.NewType, subtype_of: :atom, constraints: [one_of: [:submit_form]]
end
