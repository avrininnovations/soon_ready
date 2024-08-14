defmodule SoonReady.SurveyManagement.IntegrationEvents.SurveyPublishedV1 do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :starting_page_id, :uuid, allow_nil?: false, public?: true
    attribute :pages, {:array, SurveyPage}, public?: true
    attribute :trigger, Trigger, public?: true
  end

  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      :pages,
      :trigger,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
