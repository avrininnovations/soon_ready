defmodule SoonReady.IdentityAndAccessManagement.Commands.MarkResearcherRegistrationAsFailed do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :error, :map, allow_nil?: false
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
    define_for SoonReady.IdentityAndAccessManagement
    define :dispatch
  end
end
