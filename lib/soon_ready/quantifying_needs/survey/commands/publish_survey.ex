defmodule SoonReady.QuantifyingNeeds.Survey.Commands.PublishSurvey do
  use Ash.Resource, data_layer: :embedded

  alias SoonReady.Application

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
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
    define_for SoonReady.QuantifyingNeeds.Survey
    define :dispatch
  end
end
