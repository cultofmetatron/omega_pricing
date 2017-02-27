use Mix.Config

config :logger,
  level: :info,
  truncate: 4096

config :price_tracker,
  ecto_repos: [PriceTracker.Repo]

config :price_tracker, PriceTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "price_tracker_repo_test",
  username: "root",
  password: "",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

