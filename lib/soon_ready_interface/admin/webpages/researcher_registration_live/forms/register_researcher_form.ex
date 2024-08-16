defmodule SoonReadyInterface.Admin.Webpages.ResearcherRegistrationLive.Forms.RegisterResearcherForm do
  use Ash.Resource, data_layer: :embedded

  alias SoonReadyInterface.Admin.Commands.RegisterResearcher

  attributes do
    attribute :first_name, :string, allow_nil?: false, public?: true
    attribute :last_name, :string, allow_nil?: false, public?: true
    attribute :username, :string, allow_nil?:  false, public?: true
    attribute :password, :string, allow_nil?: false, public?: true
    attribute :password_confirmation, :string, allow_nil?: false, public?: true
  end

  validations do
    validate confirm(:password, :password_confirmation)
  end

  actions do
    default_accept [
      :first_name,
      :last_name,
      :username,
      :password,
      :password_confirmation,
    ]

    defaults [:create]
  end
end
