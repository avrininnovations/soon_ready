# Setup database
mix ecto.setup
mix event_store.setup

# Make server file executable
chmod a+x _build/prod/rel/soon_ready/bin/soon_ready

# Start server
_build/prod/rel/soon_ready/bin/soon_ready start_iex
