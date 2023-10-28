defmodule SoonReady.Vault.PersonallyIdentifiableInformationCipher do
  @behaviour Cloak.Cipher

  @key "Y/tty5KdmwYC1PoY+i7Fp18umZhYfDRw8DjcFrMFDVg=" |> Base.decode64!()

  @impl true
  def encrypt(plaintext, opts) do
    opts = put_in(opts[:key], @key)
    Cloak.Ciphers.AES.GCM.encrypt(plaintext, opts)
  end

  @impl true
  def decrypt(ciphertext, opts) do
    IO.inspect(:DECRYPT)
    opts = put_in(opts[:key], @key)
    Cloak.Ciphers.AES.GCM.decrypt(ciphertext, opts)
  end

  @impl true
  def can_decrypt?(ciphertext, opts) do
    opts = put_in(opts[:key], @key)
    Cloak.Ciphers.AES.GCM.can_decrypt?(ciphertext, opts)
  end
end
