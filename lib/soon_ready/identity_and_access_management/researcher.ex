defmodule SoonReady.IdentityAndAccessManagement.Researcher do
  use Ash.Resource, data_layer: :embedded
  use Commanded.Commands.Router

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher
  alias SoonReady.IdentityAndAccessManagement.Events.ResearcherRegisteredV1, as: ResearcherRegistered

  attributes do
    uuid_primary_key :researcher_id
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement.Api
    define :create
  end

  dispatch RegisterResearcher, to: __MODULE__, identity: :researcher_id

  def execute(_aggregate_state, %RegisterResearcher{} = command) do
    with {:ok, %{id: user_id} = user} <- SoonReady.IdentityAndAccessManagement.UserAccount.register_user_with_password(command.username, command.password, command.password_confirmation) do
      ResearcherRegistered.create(%{researcher_id: command.researcher_id, user_id: user_id, first_name: command.first_name, last_name: command.last_name})
    end
  end

  def apply(state, %ResearcherRegistered{researcher_id: id} = _event) do
    __MODULE__.create(%{id: id})
  end
end
