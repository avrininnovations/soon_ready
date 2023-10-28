defmodule SoonReady.Vault.PersonallyIdentifiableInformationCipher2 do
  @behaviour Cloak.Cipher

  @key "Y/tty5KdmwYC1PoY+i7Fp18umZhYfDRw8DjcFrMFDVg=" |> Base.decode64!()

  def key!(opts) do
    # resource = Keyword.fetch!(opts, :resource)
    # get_function = Keyword.fetch!(opts, :get_function)
    # args = Keyword.fetch!(opts, :args)
    # cloak_key_field = Keyword.fetch!(opts, :cloak_key_field)

    # record = apply(resource, get_function, args)
    # cloak_key = Map.get(record, cloak_key_field)
    # Base.decode64!(cloak_key)


    "Y/tty5KdmwYC1PoY+i7Fp18umZhYfDRw8DjcFrMFDVg=" |> Base.decode64!()
  end

  @impl true
  def encrypt(plaintext, opts) do
    opts = put_in(opts[:key], key!(opts))
    Cloak.Ciphers.AES.GCM.encrypt(plaintext, opts)
  end

  @impl true
  def decrypt(ciphertext, opts) do
    IO.inspect(:DECRYPT_2)
    opts = put_in(opts[:key], key!(opts))
    Cloak.Ciphers.AES.GCM.decrypt(ciphertext, opts)
  end

  @impl true
  def can_decrypt?(ciphertext, opts) do
    IO.inspect(:can_decrypt_2)
    opts = put_in(opts[:key], key!(opts))
    Cloak.Ciphers.AES.GCM.can_decrypt?(ciphertext, opts)
    false
  end
end
