defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        onboarding: {
          SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher,
          tag: "Onboarding",
        },
        default: {
          Cloak.Ciphers.AES.GCM,
          tag: "AES.GCM.V1",
          key: cloak_key!(),
          iv_length: 12
        },
      ])

    {:ok, config}
  end

  defp cloak_key!() do
    :soon_ready
    |> Application.get_env(:cloak_key)
    |> Base.decode64!()
  end
end
