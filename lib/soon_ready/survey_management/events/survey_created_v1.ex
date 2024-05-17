defmodule SoonReady.SurveyManagement.Events.SurveyCreatedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  alias SoonReady.SurveyManagement.DomainObjects.{SurveyPage, Trigger}

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
    attribute :pages, {:array, SurveyPage}
    attribute :trigger, Trigger
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.SurveyManagement
    define :new
  end
end
