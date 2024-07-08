defmodule SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration do
  use Ash.Resource, domain: SoonReady.IdentityAndAccessManagement

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false, default: &Ash.UUID.generate/0
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
      :researcher_id,
      :first_name,
      :last_name,
      :username,
      :password,
      :password_confirmation,
    ]

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
    define :dispatch
  end
end
