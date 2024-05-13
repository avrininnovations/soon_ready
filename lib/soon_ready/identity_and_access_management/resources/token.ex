defmodule SoonReady.IdentityAndAccessManagement.Resources.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api SoonReady.IdentityAndAccessManagement
  end

  postgres do
    table "identity_and_access_management__resources__tokens"
    repo SoonReady.Repo
  end

  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
