{:ok, _} = Application.ensure_all_started(:ex_machina)
#{:ok, _} = Application.ensure_all_started(:repo)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PriceTracker.Repo, :manual)

