import Config

# Configure vault encryption
config :soon_ready, cloak_key: "WMecPlmzEqqczOf3v95r38L6vOsAeAWpyeBHbypLi48="

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :soon_ready, SoonReady.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "soon_ready_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :soon_ready, SoonReady.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "soon_ready_test#{System.get_env("MIX_TEST_PARTITION")}",
  schema: "event_store",
  hostname: "localhost",
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :soon_ready, SoonReadyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8U9sc96Mq3KRMmTradgKFD5wua3dJ5olRmxbuDptdcdghx06QUoZBFKOno5k7rMB",
  server: false

# In test we don't send emails.
config :soon_ready, SoonReady.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
