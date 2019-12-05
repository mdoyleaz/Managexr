# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :managexr,
  ecto_repos: [Managexr.Repo]

# Configures the endpoint
config :managexr, ManagexrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Cax4qRUNbhljuEsNBLOh9dPGNqmNgEPYECW6lMEJFhAKr6FccdLi2fI1acwNAtNf",
  render_errors: [view: ManagexrWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Managexr.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Token Sweeper
config :managexr, :token_sweeper,
  # ttl in Minutes
  ttl: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
