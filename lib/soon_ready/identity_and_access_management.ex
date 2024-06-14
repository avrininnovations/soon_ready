# defmodule SoonReady.IdentityAndAccessManagement do
#   use Ash.Api

#   alias SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration

#   resources do
#     resource SoonReady.IdentityAndAccessManagement.Resources.User
#     resource SoonReady.IdentityAndAccessManagement.Resources.Token
#     resource SoonReady.IdentityAndAccessManagement.Resources.Researcher
#   end

#   defdelegate initiate_researcher_registration(params), to: InitiateResearcherRegistration, as: :dispatch
#   defdelegate get_researcher(researcher_id), to: SoonReady.IdentityAndAccessManagement.Resources.Researcher, as: :get
# end
