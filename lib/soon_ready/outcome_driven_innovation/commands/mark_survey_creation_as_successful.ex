defmodule SoonReady.OutcomeDrivenInnovation.Commands.MarkSurveyCreationAsSuccessful do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Application

  attributes do
    attribute :project_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :survey_id, :uuid, allow_nil?: false
  end

  actions do
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
    define_for SoonReady.OutcomeDrivenInnovation
    define :dispatch
  end
end
