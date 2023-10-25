# Setup database
mix ecto.setup
mix event_store.create
mix event_store.init

# Make server file executable
chmod a+x _build/prod/rel/soon_ready/bin/server

# Start server
_build/prod/rel/soon_ready/bin/server
