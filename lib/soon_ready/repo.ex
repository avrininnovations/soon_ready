defmodule SoonReady.Repo do
  use Ecto.Repo,
    otp_app: :soon_ready,
    adapter: Ecto.Adapters.Postgres
end
