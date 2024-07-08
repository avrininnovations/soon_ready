defmodule SoonReady.SurveyManagement.DomainEvents.SurveyPublishedV1 do
  use Ash.Resource,
    domain: SoonReady.SurveyManagement,
    extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true, public?: true
  end

  actions do
    default_accept [
      :survey_id,
    ]
    create :new
  end

  code_interface do
    define :new
  end
end
