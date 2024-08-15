defmodule SoonReady.OutcomeDrivenInnovation do
  use Ash.Domain

  alias SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey

  resources do
    resource SoonReady.OutcomeDrivenInnovation.ResearchProject

    resource SoonReady.OutcomeDrivenInnovation.Commands.CreateSurvey
    resource SoonReady.OutcomeDrivenInnovation.Commands.MarkSurveyCreationAsSuccessful

    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.ProjectCreatedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.MarketDefinedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.NeedsDefinedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.SurveyCreationRequestedV1
    resource SoonReady.OutcomeDrivenInnovation.DomainEvents.SurveyCreationSucceededV1
  end

  authorization do
    authorize :by_default
  end


  # TODO: Remove all defdelegates
  defdelegate create_survey(params), to: CreateSurvey, as: :dispatch
  # def create_survey(params, actor \\ nil), do: CreateSurvey.dispatch(params, [actor: actor])
end
