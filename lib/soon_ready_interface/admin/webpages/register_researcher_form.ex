defmodule SoonReadyInterface.Admin.Webpages.RegisterResearcherForm do
  use Ash.Resource

  alias SoonReady.UserAuthentication.Commands.RegisterResearcher

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

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn _changeset, resource ->
          %{first_name: first_name, last_name: last_name, username: username, password: password} = resource
          with :ok <- RegisterResearcher.dispatch(%{first_name: first_name, last_name: last_name, username: username, password: password}) do
            {:ok, resource}
          end
        end)
      end
    end
  end
end
