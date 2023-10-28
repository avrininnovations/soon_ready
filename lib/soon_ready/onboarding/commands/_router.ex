defmodule SoonReady.Onboarding.Commands.Router do
  use Ash.Resource
  use Commanded.Commands.Router

  alias SoonReady.Onboarding.Commands.JoinWaitlist

  identify __MODULE__, by: :id
  dispatch [JoinWaitlist], to: __MODULE__

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
  end

  def execute(aggregate_state, %JoinWaitlist{} = command) do
    JoinWaitlist.execute(command, aggregate_state)
  end

  def apply(state, _event) do
    state
  end
end
