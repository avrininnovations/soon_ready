defmodule SoonReady.UserAuthentication.Api do
  use Ash.Api

  resources do
    resource SoonReady.UserAuthentication.Encryption.EncryptionKey
  end
end
