defmodule SoonReady.IdentityAndAccessManagement.Api do
  use Ash.Api

  resources do
    resource SoonReady.Encryption.PersonalIdentifiableInformationEncryptionKey
  end
end
