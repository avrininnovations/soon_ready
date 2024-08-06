defmodule SoonReadyInterface.Admin.Webpages.RegisterResearcherForm do
  use Ash.Resource

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

  attributes do
    uuid_primary_key :researcher_id
    attribute :first_name, :string, allow_nil?: false, public?: true
    attribute :last_name, :string, allow_nil?: false, public?: true
    attribute :username, :string, allow_nil?:  false, public?: true
    attribute :password, :string, allow_nil?: false, public?: true
    attribute :password_confirmation, :string, allow_nil?: false, public?: true
  end

  actions do
    default_accept [
      :first_name,
      :last_name,
      :username,
      :password,
      :password_confirmation,
    ]
    create :submit do
      primary? true

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn _changeset, resource ->
          %{
            researcher_id: researcher_id,
            first_name: first_name,
            last_name: last_name,
            username: username,
            password: password,
            password_confirmation: password_confirmation
          } = resource

          params = %{
            researcher_id: researcher_id,
            first_name: first_name,
            last_name: last_name,
            username: username,
            password: password,
            password_confirmation: password_confirmation
          }

          with :ok <- RegisterResearcher.dispatch(params) do
            {:ok, resource}
          end
        end)
      end
    end
  end
end
