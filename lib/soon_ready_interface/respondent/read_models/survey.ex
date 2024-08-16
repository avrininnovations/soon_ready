defmodule SoonReadyInterface.Respondent.ReadModels.Survey do
  # TODO: Restore to postgres
  # use Ash.Resource, data_layer: AshPostgres.DataLayer
  use Ash.Resource,
    domain: SoonReadyInterface.Respondent,
    data_layer: AshPostgres.DataLayer
    # data_layer: Ash.DataLayer.Ets

  use Commanded.Event.Handler,
    application: SoonReady.Application,
    name: "#{__MODULE__}",
    consistency: Application.get_env(:soon_ready, :consistency, :eventual)

  alias SoonReady.SurveyManagement.V1.DomainEvents.SurveyPublished
  alias SoonReady.SurveyManagement.V1.DomainConcepts.SurveyPage

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :starting_page_id, :uuid, allow_nil?: false
    attribute :pages, {:array, SurveyPage}
    attribute :is_active, :boolean, allow_nil?: false, default: false
  end

  actions do
    default_accept [
      :id,
      :starting_page_id,
      :pages,
      :is_active,
    ]
    defaults [:create, :read, :update]

    read :get do
      get_by :id
    end

    read :get_active do
      get_by :id
      filter expr(is_active == true)
    end
  end

  code_interface do
    define :create
    define :read
    define :get do
      args [:id]
    end
    define :get_active do
      args [:id]
    end
    define :update
  end

  # TODO: Check all postgres names for issues
  postgres do
    repo SoonReady.Repo
    table "respondents__read_models__survey"
  end


  # TODO: Check
  def handle(%SurveyPublished{} = event, _metadata) do
    %{
      survey_id: survey_id,
      starting_page_id: starting_page_id,
      pages_dumped_data: pages_dumped_data,
      trigger: trigger
    } = event

    params = %{
      survey_id: survey_id,
      starting_page_id: starting_page_id,
      pages_dumped_data: pages_dumped_data,
      trigger: trigger
    }

    {:ok, %{pages: pages}} = SurveyPublished.new(params)

    with {:ok, _active_odi_survey} <- __MODULE__.create(%{
      id: survey_id,
      starting_page_id: starting_page_id,
      pages: pages,
      is_active: true,
    }) do
      :ok
    end
  end
end
