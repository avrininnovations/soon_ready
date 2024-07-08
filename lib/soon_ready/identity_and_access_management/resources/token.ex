defmodule SoonReady.IdentityAndAccessManagement.Resources.Token do
  use Ash.Resource,
    domain: SoonReady.IdentityAndAccessManagement,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

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
