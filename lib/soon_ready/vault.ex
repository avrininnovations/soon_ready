defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        personally_identifiable_information: {
          SoonReady.Vault.PersonallyIdentifiableInformationCipher2,
          tag: "AES.GCM.V1",
          iv_length: 12
        },
        personally_identifiable_information: {
          SoonReady.Vault.PersonallyIdentifiableInformationCipher,
          tag: "AES.GCM.V1",
          iv_length: 12
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
