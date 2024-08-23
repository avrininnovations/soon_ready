defmodule SoonReadyInterface.Admin.Aggregates.Researcher do
  use Ash.Resource, domain: SoonReadyInterface.Admin
  use Commanded.Commands.Router

  alias SoonReadyInterface.Admin.Commands.RegisterResearcher
  alias SoonReady.IdentityAndAccessManagement.V1.DomainEvents.ResearcherRegistered

  attributes do
    uuid_primary_key :researcher_id
  end

  actions do
    defaults [:create, :read]
  end

  code_interface do
    define :create
  end

  dispatch RegisterResearcher, to: __MODULE__, identity: :researcher_id

  def execute(_aggregate_state, %RegisterResearcher{} = command) do
    %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    } = command

    params = %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    }

    ResearcherRegistered.create(params)
  end

  def apply(state, _event) do
    state
  end
end
