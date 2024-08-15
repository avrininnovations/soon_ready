defmodule SoonReady.SurveyManagement.DomainConcepts.Survey do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.SurveyPage

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false, default: &Ash.UUID.generate/0
    attribute :starting_page_id, :uuid, allow_nil?: false
    attribute :pages, {:array, SurveyPage}, constraints: [min_length: 1]
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages,
    ]

    defaults [:create, :read]
  end

  code_interface do
    define :create
  end
end
