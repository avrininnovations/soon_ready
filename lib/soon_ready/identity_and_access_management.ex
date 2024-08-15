defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Domain

  resources do
    # Resources
    resource SoonReady.IdentityAndAccessManagement.Resources.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
    resource SoonReady.IdentityAndAccessManagement.Resources.Researcher

    # DomainEvents
    resource SoonReady.IdentityAndAccessManagement.Events.V1.ResearcherRegistered
  end
end
