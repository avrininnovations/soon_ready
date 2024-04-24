defmodule SoonReady.UserAuthentication.Commands.RegisterResearcher do
  use Ash.Resource, data_layer: :embedded

  attributes do
    uuid_primary_key :id
    attribute :first_name, :string, allow_nil?: false
    attribute :last_name, :string, allow_nil?: false
    attribute :username, :string, allow_nil?:  false
    attribute :password, :string, allow_nil?: false
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
    define_for SoonReady.UserAuthentication.Api
    define :dispatch
  end
end
