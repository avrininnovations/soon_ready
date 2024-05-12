defmodule SoonReady.IdentityAndAccessManagement do
  use Ash.Api

  alias SoonReady.IdentityAndAccessManagement.Commands.RegisterResearcher

  resources do
    # TODO: Move this out
    resource SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey
    
    resource SoonReady.UserAuthentication.Entities.User
    resource SoonReady.IdentityAndAccessManagement.Resources.Token
  end

  defdelegate register_researcher(params), to: RegisterResearcher, as: :dispatch
end
