defmodule SoonReady.UserAuthentication.Commands.RegisterResearcher do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false
    attribute :username, :string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
  end

  actions do
    create :dispatch do
      primary? true
    end
  end

  code_interface do
    define_for SoonReady.UserAuthentication.Api
    define :dispatch
  end
end
