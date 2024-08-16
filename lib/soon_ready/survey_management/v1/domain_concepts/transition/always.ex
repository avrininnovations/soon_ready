defmodule SoonReady.SurveyManagement.V1.DomainConcepts.Transition.Always do
  use Ash.Type.NewType, subtype_of: :atom, constraints: [one_of: [:always]]
end
