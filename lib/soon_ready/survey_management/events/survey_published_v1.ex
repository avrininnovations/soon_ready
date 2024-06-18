defmodule SoonReady.SurveyManagement.Events.SurveyPublishedV1 do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainConcepts.Trigger

  # TODO: Duplicate out into integration event, remove trigger
  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
    attribute :trigger, Trigger, public?: true
  end

  actions do
    default_accept [
      :survey_id,
      :trigger,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
