use Mix.Config

# Configure your database
config :managexr, Managexr.Repo,
  username: "postgres",
  password: "postgres",
  database: "managexr_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :managexr_web, ManagexrWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# [Authenticator] - Guardian
config :authentication, Authentication.Guardian,
  issuer: "authentication",
  secret_key: "ovbJRACYXpTubFdhoTAZO2xVFGckzJ52lVeCaRlofmTnEJ4xm8QNZ5d79Lh9HzRx",
  serializer: Authenticator.GuardianSerializer
