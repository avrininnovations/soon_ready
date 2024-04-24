defmodule SoonReadyInterface.Admin.Webpages.RegisterResearcherForm do
  use Ash.Resource

  attributes do
    uuid_primary_key :id
    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false
    attribute :username, :string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
  end

  actions do
    create :submit do
      primary? true
    end
  end
end
