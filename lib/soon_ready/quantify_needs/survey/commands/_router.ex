defmodule SoonReady.SurveyManagement.Commands.Router do
  use Ash.Resource, data_layer: :embedded
  use Commanded.Commands.Router

  alias SoonReady.SurveyManagement.Commands.PublishOdiSurvey

  attributes do
    attribute :survey_id, :uuid, allow_nil?: false
  end

  dispatch PublishOdiSurvey, to: __MODULE__, identity: :survey_id

  def execute(aggregate_state, %{__struct__: command_module_name} = command) do
    # Delegate to the command module
    apply(command_module_name, :execute, [command, aggregate_state])
  end

  def apply(state, _event) do
    state
  end
end
