defmodule SoonReady.QuantifyNeeds.Survey.DomainEvents.SurveyPublished do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :event_version, :integer, default: 1
  end

  actions do
    create :new
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.Survey.Api
    define :new
  end
end
