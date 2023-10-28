defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        onboarding: {
          SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher,
          tag: "Onboarding",
        },
      ])

    {:ok, config}
  end
end
