defmodule SoonReady.IdentityAndAccessManagement.Resources.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api SoonReady.IdentityAndAccessManagement.UserAccount
  end

  postgres do
    table "user_authentication__entities__tokens"
    repo SoonReady.Repo
  end

  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
