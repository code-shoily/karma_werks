use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :karma_werks, KarmaWerksWeb.Endpoint,
  http: [port: 4002],
  server: false

config :karma_werks, :dgraph_port, 19080

# Print only warnings and errors during test
config :logger, level: :warn
