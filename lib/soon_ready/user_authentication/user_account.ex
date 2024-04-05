defmodule SoonReady.UserAuthentication.UserAccount do
  use Ash.Api

  resources do
    resource SoonReady.UserAuthentication.Entities.User
    resource SoonReady.UserAuthentication.Entities.Token
  end
end
