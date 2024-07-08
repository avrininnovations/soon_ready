defmodule SoonReady.Cipher do
  require Logger
  @behaviour Cloak.Cipher

  @impl true
  def encrypt(%{key: key, plain_text: plain_text}, opts) when is_binary(key) and is_binary(plain_text) do
    opts = put_in(opts[:key], key)

    with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
      {:ok, Base.encode64(cipher_text)}
    end
  end

  def encrypt(plain_text, opts) when is_binary(plain_text) do
    with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
      {:ok, Base.encode64(cipher_text)}
    end
  end

  def encrypt(_value, _opts) do
    Logger.warning("Encryption failed")
    :error
  end

  @impl true
  def decrypt(%{key: key, cipher_text: cipher_text}, opts) when is_binary(key) and is_binary(cipher_text) do
    opts = put_in(opts[:key], key)

    cipher_text
    |> Base.decode64!()
    |> Cloak.Ciphers.AES.GCM.decrypt(opts)
  end

  def decrypt(cipher_text, opts) when is_binary(cipher_text) do
    cipher_text
    |> Base.decode64!()
    |> Cloak.Ciphers.AES.GCM.decrypt(opts)
  end

  def decrypt(_value, _opts) do
    Logger.warning("Decryption failed")
    :error
  end

  @impl true
  def can_decrypt?(%{key: key, cipher_text: cipher_text}, opts) when is_binary(key) and is_binary(cipher_text) do
    opts = put_in(opts[:key], key)

    cipher_text
    |> Base.decode64!()
    |> Cloak.Ciphers.AES.GCM.can_decrypt?(opts)
  end

  def can_decrypt?(cipher_text, opts) when is_binary(cipher_text) do
    cipher_text
    |> Base.decode64!()
    |> Cloak.Ciphers.AES.GCM.can_decrypt?(opts)
  end

  def can_decrypt?(_value, _opts) do
    false
  end
end
