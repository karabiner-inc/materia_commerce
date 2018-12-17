use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :materia_commerce, MateriaCommerceWeb.Test.Endpoint,
  http: [port: 4001],
  #server: false,
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :info

# Configure your database
config :materia_commerce, MateriaCommerce.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "materia_commerce_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :materia_commerce, repo: MateriaCommerce.Test.Repo

# Configures GuardianDB
config :guardian, Guardian.DB,
 repo: MateriaCommerce.Test.Repo,
 schema_name: "guardian_tokens", # default
#token_types: ["refresh_token"], # store all token types if not set
 sweep_interval: 60 # default: 60 minutes