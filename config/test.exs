use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :healthlocker, Healthlocker.Endpoint,
  http: [port: 4001],
  server: true

config :healthlocker, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :healthlocker, Healthlocker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "healthlocker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :healthlocker, Healthlocker.ReadOnlyRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "epjs_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :healthlocker, :analytics, Healthlocker.Analytics.Local

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

config :appsignal, :config, active: false

config :wallaby, screenshot_on_failure: true
config :wallaby, phantomjs_args: "--proxy-type=none"
