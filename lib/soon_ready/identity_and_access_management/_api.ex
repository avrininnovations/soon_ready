defmodule SoonReady.IdentityAndAccessManagement.Api do
  use Ash.Api

  resources do
    resource SoonReady.IdentityAndAccessManagement.Resources.PiiEncryptionKey
  end
end
