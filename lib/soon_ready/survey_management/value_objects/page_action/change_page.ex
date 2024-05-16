defmodule SoonReady.SurveyManagement.ValueObjects.PageAction.ChangePage do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :destination_page_id, :uuid, allow_nil?: false
  end
end
