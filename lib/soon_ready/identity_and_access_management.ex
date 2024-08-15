defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Domain

  alias SoonReadyInterface.Admin.Commands.RegisterResearcher

  resources do
    # Aggregates
    resource SoonReadyInterface.Admin.Commands.Handlers.Researcher

    # Resources
    resource SoonReady.IdentityAndAccessManagement.Resources.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
    resource SoonReady.IdentityAndAccessManagement.Resources.Researcher

    # Commands
    resource SoonReadyInterface.Admin.Commands.RegisterResearcher do
      define :initiate_researcher_registration, action: :dispatch
    end

    # DomainEvents
    resource SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered
  end
end
