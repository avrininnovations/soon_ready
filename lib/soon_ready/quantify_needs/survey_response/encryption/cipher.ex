defmodule SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets
  # TODO: Update to postgres

  require Logger
  @behaviour Cloak.Cipher

  attributes do
    attribute :id, :uuid, allow_nil?: false, primary_key?: true
    attribute :cloak_key, :string, allow_nil?: false
  end

  actions do
    defaults [:read, :destroy]

    create :initialize do
      primary? true

      change fn changeset, _context ->
        Ash.Changeset.change_attribute(changeset, :cloak_key, 32 |> :crypto.strong_rand_bytes() |> Base.encode64())
      end
    end

    read :get do
      get_by [:id]
    end
  end

  code_interface do
    define_for SoonReady.QuantifyNeeds.SurveyResponse.Api
    define :initialize
    define :get
    define :read
    define :destroy
  end

  def encrypt_text(plain_text, %{__struct__: __MODULE__, id: survey_response_id} = _cipher) when is_binary(plain_text) do
    with :error <- SoonReady.Vault.encrypt(%{id: survey_response_id, plain_text: plain_text}, __MODULE__) do
      Logger.warning("Encryption failed")
      {:error, :encryption_failed}
    end
  end

  def encrypt_text(nil, %{__struct__: __MODULE__}) do
    {:ok, nil}
  end

  def encrypt_text(_plain_text, _cipher) do
    Logger.warning("Encryption failed")
    {:error, :encryption_failed}
  end

  def decrypt_text(cipher_text) do
    with :error <- SoonReady.Vault.decrypt(cipher_text) do
      Logger.warning("Decryption failed")
      {:error, :decryption_failed}
    end
  end

  def get_key(survey_response_id) do
    with {:ok, %{__struct__: __MODULE__, cloak_key: cloak_key}} <- __MODULE__.get(%{id: survey_response_id}) do
      {:ok, Base.decode64!(cloak_key)}
    end
  end

  @impl true
  def encrypt(%{id: survey_response_id, plain_text: plain_text}, opts) when is_binary(plain_text) do
    case __MODULE__.get_key(survey_response_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        with {:ok, cipher_text} <- Cloak.Ciphers.AES.GCM.encrypt(plain_text, opts) do
          {:ok, Base.encode64(cipher_text)}
        end
      {:error, error} ->
        Logger.warning("Encryption failed for survey_response_id: #{survey_response_id}. Error: #{error}")
        :error
    end
  end

  def encrypt(_value, _opts) do
    Logger.warning("Encryption failed")
    :error
  end

  @impl true
  def decrypt(%{id: survey_response_id, plain_text: cipher_text}, opts) when is_binary(cipher_text) do
    case __MODULE__.get_key(survey_response_id) do
      {:ok, key} ->
        opts = put_in(opts[:key], key)

        cipher_text
        |> Base.decode64!()
        |> Cloak.Ciphers.AES.GCM.decrypt(opts)
      {:error, error} ->
        Logger.warning("Decryption failed for survey_response_id: #{survey_response_id}. Error: #{error}")
        :error
    end
  end

  def decrypt(_value, _opts) do
    Logger.warning("Decryption failed")
    :error
  end

  @impl true
  def can_decrypt?(%{id: survey_response_id, plain_text: cipher_text}, opts) when is_binary(cipher_text) do
    case __MODULE__.get_key(survey_response_id) do
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
