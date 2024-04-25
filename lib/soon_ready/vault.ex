defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  # WARNING: The chosen tag gets embedded in the encrypted text
  # This means that if you change the tag, you will not be able to decrypt the text
  # This is a feature of the Cloak library

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        default: {
          SoonReady.Cipher,
          tag: "#{SoonReady.Cipher}",
          key: get_cloak_key_env()
        },
        onboarding: {
          SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher,
          tag: "Onboarding",
        }
      ])

    {:ok, config}
  end

  defp get_cloak_key_env() do
    Application.get_env(:soon_ready, :cloak_key)
    |> Base.decode64!()
  end
end
