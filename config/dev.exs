use Mix.Config

config :price_tracker,
  ecto_repos: [PriceTracker.Repo]

config :price_tracker, PriceTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "price_tracker_repo",
  username: "root",
  password: "",
  hostname: "localhost"


