defmodule SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher do
  use Ash.Resource, data_layer: :embedded

  attributes do
    uuid_primary_key :researcher_id
    attribute :first_name, :ci_string, allow_nil?: false
    attribute :last_name, :ci_string, allow_nil?: false
    attribute :username, :ci_string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
    attribute :password_confirmation, :string, allow_nil?: false
  end

  actions do
    create :dispatch do
      primary? true

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- SoonReady.Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement.Api
    define :dispatch
  end
end
