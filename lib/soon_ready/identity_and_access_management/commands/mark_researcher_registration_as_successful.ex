defmodule SoonReady.IdentityAndAccessManagement.Commands.MarkResearcherRegistrationAsSuccessful do
  use Ash.Resource, domain: SoonReady.IdentityAndAccessManagement

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :user_id, :uuid, allow_nil?: false
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
    define :dispatch
  end
end
