defmodule PriceTracker.OmegaStrategyTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  setup_all do
    ExVCR.Config.cassette_library_dir(
      Path.expand("../fixture/vcr_cassettes", __DIR__),
      Path.expand("../fixture/custom_cassettes", __DIR__))
    :ok
  end
  
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PriceTracker.Repo)
  end

  alias PriceTracker.Repo
  alias PriceTracker.Product
  import PriceTracker.Factory
  alias PriceTracker.Transactor
  
  describe "omega strategy" do
    
  end

  

end
