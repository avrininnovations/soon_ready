defmodule SoonReady.Repo do
  use AshPostgres.Repo, otp_app: :soon_ready

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
