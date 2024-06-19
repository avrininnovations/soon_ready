defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Domain

  alias SoonReady.OutcomeDrivenInnovation.Commands.{
    CreateProject,
    DefineMarket,
    DefineNeeds,
    CreateSurvey,
  }

  resources do
    resource SoonReady.OutcomeDrivenInnovation.ResearchProject

    resource SoonReady.OutcomeDrivenInnovation.Commands.CreateProject
    resource SoonReady.OutcomeDrivenInnovation.Commands.DefineMarket
    resource SoonReady.OutcomeDrivenInnovation.Commands.DefineNeeds
    resource SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey
    resource SoonReady.OutcomeDrivenInnovation.Commands.MarkSurveyCreationAsSuccessful

    resource SoonReady.OutcomeDrivenInnovation.Events.ProjectCreatedV1
    resource SoonReady.OutcomeDrivenInnovation.Events.MarketDefinedV1
    resource SoonReady.OutcomeDrivenInnovation.Events.NeedsDefinedV1
    resource SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationRequestedV1
    resource SoonReady.OutcomeDrivenInnovation.Events.SurveyCreationSucceededV1
  end

  authorization do
    authorize :by_default
  end


  # TODO: Remove all defdelegates
  defdelegate create_project(params), to: CreateProject, as: :dispatch
  defdelegate define_market(params), to: DefineMarket, as: :dispatch
  defdelegate define_needs(params), to: DefineNeeds, as: :dispatch
  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  # def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
end
