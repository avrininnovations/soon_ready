defmodule SoonReadyInterface.Admin.Commands.RegisterResearcher do
  use Ash.Resource, domain: SoonReadyInterface.Admin

  attributes do
    uuid_primary_key :researcher_id
    attribute :first_name, :ci_string, allow_nil?: false
    attribute :last_name, :ci_string, allow_nil?: false
    attribute :username, :ci_string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
    attribute :password_confirmation, :string, allow_nil?: false
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

    create :dispatch do
      primary? true

      # TODO: Validate username is not already taken
      # Use a ETS based read model

      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- SoonReady.Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end
end
