defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Domain

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

  resources do
    # Aggregates
    resource SoonReady.IdentityAndAccessManagement.Researcher

    # Resources
    resource SoonReady.IdentityAndAccessManagement.Resources.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
    resource SoonReady.IdentityAndAccessManagement.Resources.Researcher

    # Commands
    resource SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

    # DomainEvents
    resource SoonReady.IdentityAndAccessManagement.DomainEvents.ResearcherRegisteredV1
  end

  defdelegate initiate_researcher_registration(params), to: RegisterResearcher, as: :dispatch
end
