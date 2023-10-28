defmodule SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher do
  @behaviour Cloak.Cipher

  alias SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails

  defp get_key(person_id) do
    case EncryptionDetails.get(%{person_id: person_id}) do
      {:ok, %{cloak_key: nil}} ->
        :error
      {:ok, %{cloak_key: cloak_key}} ->
        {:ok, Base.decode64!(cloak_key)}
      {:error, _error} ->
        :error
    end
  end

  @impl true
  def encrypt(%{person_id: person_id, plain_text: plain_text}, opts) when is_binary(plain_text) do
    with {:ok, key} <- get_key(person_id) do
      opts = put_in(opts[:key], key)

      with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
        {:ok, Base.encode64(cipher_text)}
      end
    end
  end

  def encrypt(_value, _opts) do
    :error
  end

  @impl true
  def decrypt(%{person_id: person_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
    with {:ok, key} <- get_key(person_id) do
      opts = put_in(opts[:key], key)

      cipher_text
      |> Base.decode64!()
      |> Cloak.Ciphers.AES.GCM.decrypt(opts)
    end
  end

  def decrypt(_value, _opts) do
    :error
  end

  @impl true
  def can_decrypt?(%{person_id: person_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
    case get_key(person_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        cipher_text
        |> Base.decode64!()
        |> Cloak.Ciphers.AES.GCM.can_decrypt?(opts)
      :error ->
        false
    end
  end

  def can_decrypt?(_value, _opts) do
    false
  end
end
