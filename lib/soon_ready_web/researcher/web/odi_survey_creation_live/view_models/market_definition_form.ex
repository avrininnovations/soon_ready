defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.MarketDefinitionForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :brand_name, :string, allow_nil?: false
    attribute :job_executor, :string, allow_nil?: false
    attribute :job_to_be_done, :string, allow_nil?: false
  end
end
