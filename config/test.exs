import Config
config :timed, token_signing_secret: "pDKZnIyeONmJoSHT5hRD5LDDofLV1hx0"
config :timed, Oban, testing: :manual

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :timed, Timed.Repo,
  username: "timed",
  password: "timed",
  hostname: "localhost",
  port: 5433,
  database: "timed_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timed, TimedWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "dR4Am1FJQytaawW9cWlJZKxU5MoL3Cb/PM1uwY+eiPu+NC5s47EDmGs4x0qiqaBR",
  server: false

# In test we don't send emails
config :timed, Timed.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :phoenix_test,
  endpoint: TimedWeb.Endpoint
