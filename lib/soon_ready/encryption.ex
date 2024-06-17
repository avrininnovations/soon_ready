defmodule SoonReady.Encryption do
  use Ash.Domain

  resources do
    resource SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey
  end
end
