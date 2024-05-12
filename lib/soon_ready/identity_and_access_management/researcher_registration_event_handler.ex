defmodule SoonReady.IdentityAndAccessManagement.ResearcherRegistrationEventHandler do
  use Commanded.Event.Handler,
    application: SoonReady.Application,
    consistency: :strong,
    name: __MODULE__

  alias SoonReady.IdentityAndAccessManagement.Events.{
    ResearcherRegistrationInitiatedV1,
    ResearcherRegistrationSucceededV1,
    ResearcherRegistrationFailedV1,
  }
  alias SoonReady.IdentityAndAccessManagement.Commands.{
    MarkResearcherRegistrationAsSuccessful,
    MarkResearcherRegistrationAsFailed,
  }

  def handle(%ResearcherRegistrationInitiatedV1{} = event, _metadata) do
    %{
      researcher_id: researcher_id,
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    } = event

    case SoonReady.UserAuthentication.Entities.User.register_user_with_password(username, password, password_confirmation) do
      {:ok, %{id: user_id} = user} ->
        {:ok, _command} = MarkResearcherRegistrationAsSuccessful.dispatch(%{researcher_id: researcher_id, user_id: user_id})
      {:error, error} ->
        {:ok, _command} = MarkResearcherRegistrationAsFailed.dispatch(%{researcher_id: researcher_id, error: error})
    end

    :ok
  end
end
