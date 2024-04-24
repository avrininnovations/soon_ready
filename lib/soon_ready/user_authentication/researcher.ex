defmodule SoonReady.UserAuthentication.Researcher do
  use Ash.Resource, data_layer: :embedded
  use Commanded.Commands.Router

  alias SoonReady.UserAuthentication.Commands.RegisterResearcher
  alias SoonReady.UserAuthentication.Events.ResearcherRegisteredV1, as: ResearcherRegistered

  attributes do
    uuid_primary_key :id
  end

  code_interface do
    define_for SoonReady.UserAuthentication.Api
    define :create
  end

  dispatch RegisterResearcher, to: __MODULE__, identity: :id

  def execute(_aggregate_state, %RegisterResearcher{} = command) do
    with {:ok, %{id: user_id} = user} <- SoonReady.UserAuthentication.UserAccount.register_user_with_password(command.username, command.password, command.password) do
      ResearcherRegistered.create(%{researcher_id: command.id, user_id: user_id, first_name: command.first_name, last_name: command.last_name})
    end
  end

  def apply(state, %ResearcherRegistered{researcher_id: id} = _event) do
    __MODULE__.create(%{id: id})
  end
end
