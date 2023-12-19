defmodule SoonReadyWeb.Researcher.Web.OdiSurveyCreationLive.ViewModels.BrandNameForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :brand_name, :string, allow_nil?: false
  end
end
