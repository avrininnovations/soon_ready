defmodule SoonReady.UserAuthentication.UserAccount do
  use Ash.Api

  resources do
    resource SoonReady.UserAuthentication.Entities.User
    resource SoonReady.UserAuthentication.Entities.Token
  end

  # TODO: Change to register researcher and add events
  def register_user_with_password(username, password, password_confirmation) do
    SoonReady.UserAuthentication.Entities.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:register, %{"username" => username, "password" => password, "password_confirmation" => password_confirmation})
  end
end
