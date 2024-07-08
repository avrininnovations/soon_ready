defmodule SoonReady.OutcomeDrivenInnovation.Commands.MarkSurveyCreationAsSuccessful do
  use Ash.Resource, domain: SoonReady.OutcomeDrivenInnovation

  alias SoonReady.Application

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :survey_id, :uuid, allow_nil?: false
  end

  actions do
    default_accept [
      :project_id,
      :survey_id,
    ]
    create :dispatch do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
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
