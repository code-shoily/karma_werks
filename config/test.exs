use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :karma_werks, KarmaWerks.Repo,
  username: "postgres",
  password: "postgres",
  database: "karma_werks_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :karma_werks, KarmaWerksWeb.Endpoint,
  http: [port: 4002],
  server: false

config :karma_werks, :dgraph_port, 19080

# Print only warnings and errors during test
config :logger, level: :warn
