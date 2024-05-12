defmodule SoonReady.OutcomeDrivenInnovation.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Event handlers
      # TODO: Move
      SoonReadyInterface.Respondents.ReadModels.Survey,

      # SoonReady.OutcomeDrivenInnovation.ReadModels.ResearcherCache
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
