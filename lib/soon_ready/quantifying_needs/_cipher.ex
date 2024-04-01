defmodule SoonReady.QuantifyingNeeds.Cipher do
  require Logger
  @behaviour Cloak.Cipher

  alias SoonReady.QuantifyingNeeds.Encryption.ResponseCloakKeys

  def encrypt_response_data(plain_text, %{__struct__: ResponseCloakKeys, response_id: response_id} = _cipher) when is_binary(plain_text) do
    with :error <- SoonReady.Vault.encrypt(%{module: ResponseCloakKeys, response_id: response_id, plain_text: plain_text}, SoonReady.QuantifyingNeeds.Cipher) do
      Logger.warning("Encryption failed")
      {:error, :encryption_failed}
    end
  end

  def encrypt_response_data(nil, %{__struct__: ResponseCloakKeys}) do
    {:ok, nil}
  end

  def encrypt_response_data(_plain_text, _cipher) do
    Logger.warning("Encryption failed")
    {:error, :encryption_failed}
  end

  def decrypt_response_data(cipher_text, for: response_id) do
    with :error <- SoonReady.Vault.decrypt(%{module: ResponseCloakKeys, response_id: response_id, cipher_text: cipher_text}) do
      Logger.warning("Decryption failed")
      {:error, :decryption_failed}
    end
  end

  @impl true
  def encrypt(%{module: ResponseCloakKeys, response_id: response_id, plain_text: plain_text}, opts) when is_binary(plain_text) do
    case ResponseCloakKeys.get_cloak_key(response_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
          {:ok, Base.encode64(cipher_text)}
        end
      {:error, error} ->
        Logger.warning("Encryption failed for response_id: #{response_id}. Error: #{error}")
        :error
    end
  end

  def encrypt(_value, _opts) do
    Logger.warning("Encryption failed")
    :error
  end

  @impl true
  def decrypt(%{module: ResponseCloakKeys, response_id: response_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
    case ResponseCloakKeys.get_cloak_key(response_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        cipher_text
        |> Base.decode64!()
        |> Cloak.Ciphers.AES.GCM.decrypt(opts)
      {:error, error} ->
        Logger.warning("Decryption failed for response_id: #{response_id}. Error: #{error}")
        :error
    end
  end

  def decrypt(_value, _opts) do
    Logger.warning("Decryption failed")
    :error
  end

  @impl true
  def can_decrypt?(%{module: ResponseCloakKeys, response_id: response_id, cipher_text: cipher_text}, opts) when is_binary(cipher_text) do
    case ResponseCloakKeys.get_cloak_key(response_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        cipher_text
        |> Base.decode64!()
        |> Cloak.Ciphers.AES.GCM.can_decrypt?(opts)
      {:error, _error} ->
        false
    end
  end

  def can_decrypt?(_value, _opts) do
    false
  end
end
