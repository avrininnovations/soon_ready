defmodule SoonReady.IdentityAndAccessManagement.Resources.Researcher do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    data_layer: AshPostgres.DataLayer

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: __MODULE__,
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.IdentityAndAccessManagement.DomainEvents.ResearcherRegistrationSucceededV1

  attributes do
    attribute :id, :uuid, primary_key?: true, allow_nil?: false
    attribute :user_id, :uuid, allow_nil?: false
  end

  relationships do
    belongs_to :user, SoonReady.IdentityAndAccessManagement.Resources.User do
      define_attribute? false
      source_attribute :user_id
    end
  end

  actions do
    default_accept [:id, :user_id]
    defaults [:create, :read]

    read :get do
      get_by [:id]

      prepare fn query, _context ->
        Ash.Query.load(query, [:user])
      end
    end
  end

  code_interface do
    define :create
    define :get, args: [:id]
  end

  postgres do
    repo SoonReady.Repo
    table "identity_and_access_management__resources__researchers"
  end

  def handle(%ResearcherRegistrationSucceededV1{researcher_id: researcher_id, user_id: user_id} = event, _metadata) do
    with {:ok, _active_odi_survey} <- __MODULE__.create(%{id: researcher_id, user_id: user_id}) do
      :ok
    end
  end
end
