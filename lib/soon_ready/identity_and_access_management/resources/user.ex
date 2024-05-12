defmodule SoonReady.UserAuthentication.Entities.User do
  # TODO: Rename
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id
    attribute :username, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true, private?: true
  end

  calculations do
    calculate :is_researcher, :boolean, fn user, _context ->
      # TODO: Update to read from researcher read model
      {:ok, true}
    end
  end

  changes do
    change load(:is_researcher)
  end

  preparations do
    prepare fn query, _context ->
      Ash.Query.load(query, :is_researcher)
    end
  end

  actions do
    defaults [:read]

    read :get do
      get_by [:id]
    end
  end

  authentication do
    api SoonReady.IdentityAndAccessManagement.UserAccount

    strategies do
      password :password do
        identity_field :username
      end
    end

    tokens do
      enabled? true
      token_resource SoonReady.IdentityAndAccessManagement.Resources.Token
      signing_secret fn _, _ ->
        Application.fetch_env(:soon_ready, :token_signing_secret)
      end
    end
  end

  # TODO: Rename table
  postgres do
    table "user_authentication__entities__users"
    repo SoonReady.Repo
  end

  identities do
    identity :unique_username, [:username]
  end

  code_interface do
    define_for SoonReady.IdentityAndAccessManagement
    define :get, args: [:id]
  end

  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end

  #   policy always() do
  #     forbid_if always()
  #   end
  # end
end
