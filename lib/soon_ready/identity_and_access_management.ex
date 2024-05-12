defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Api

  alias SoonReady.IdentityAndAccessManagement.Commands.InitiateResearcherRegistration

  resources do
    # TODO: Move this out
    resource SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey

    resource SoonReady.UserAuthentication.Entities.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
  end

  defdelegate initiate_researcher_registration(params), to: InitiateResearcherRegistration, as: :dispatch
  def get_user(user_id) do
    SoonReady.UserAuthentication.Entities.User.get(user_id)
  end
end
