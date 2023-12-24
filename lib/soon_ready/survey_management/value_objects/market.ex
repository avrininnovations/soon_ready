defmodule SoonReady.SurveyManagement.ValueObjects.Market do
  use Ash.Resource, data_layer: :embedded, extensions: [SoonReady.Ash.Extensions.JsonEncoder]

  attributes do
    attribute :job_executor, :string, allow_nil?: false
    attribute :job_to_be_done, :string, allow_nil?: false
  end
end
