defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Forms.LandingPageForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :brand_name, :string, allow_nil?: false, public?: true
  end
end
