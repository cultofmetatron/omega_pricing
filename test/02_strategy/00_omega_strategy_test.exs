defmodule PriceTracker.OmegaStrategyTest do
  use ExUnit.Case
  
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
