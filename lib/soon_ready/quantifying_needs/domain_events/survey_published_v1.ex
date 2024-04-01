defmodule SoonReady.QuantifyingNeeds.DomainEvents.SurveyPublishedV1 do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false, primary_key?: true
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyingNeeds.Survey
    define :new
  end
end
