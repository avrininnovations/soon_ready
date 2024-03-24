defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  # WARNING: The chosen tag gets embedded in the encrypted text
  # This means that if you change the tag, you will not be able to decrypt the text
  # This is a feature of the Cloak library

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        {:onboarding, {
          SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher,
          tag: "Onboarding",
        }},
        {SoonReady.QuantifyingNeeds.Cipher, {
          SoonReady.QuantifyingNeeds.Cipher,
          tag: "#{SoonReady.QuantifyingNeeds.Cipher}"
        }}
      ])

    {:ok, config}
  end
end
