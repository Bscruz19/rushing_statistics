use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rushing_statistics, RushingStatistics.Repo,
  username: "postgres",
  password: "postgres",
  database: "rushing_statistics_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rushing_statistics, RushingStatisticsWeb.Endpoint,
  http: [port: 4002],
  server: false

config :rushing_statistics, file_path: "./test/support/fixtures/rushing_mock.json"

# Print only warnings and errors during test
config :logger, level: :warn
