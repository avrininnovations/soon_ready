defmodule SoonReadyInterface.Researcher.ReadModels.ResearcherCache do
  # TODO: Rename folder from read_models to cache or test_cache
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.IdentityAndAccessManagement.Events.ResearcherRegistrationSucceededV1

  attributes do
    attribute :researcher_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :user, :map, allow_nil?: false
  end

  actions do
    defaults [:create, :read]

    read :get do
      get_by [:researcher_id]
    end
  end

  code_interface do
    define_for SoonReadyInterface.Researcher.Api
    define :create
    define :get, args: [:researcher_id]
  end

  def handle(%ResearcherRegistrationSucceededV1{researcher_id: researcher_id, user_id: user_id} = event, _metadata) do
    {:ok, user} = SoonReady.UserAuthentication.Entities.User.get(user_id)

    with {:ok, _active_odi_survey} <- __MODULE__.create(%{researcher_id: researcher_id, user: user}) do
      :ok
    end
  end
end
