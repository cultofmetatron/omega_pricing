defmodule PriceTracker.PriceTest do
  use ExUnit.Case
  #doctest PriceTracker
  alias PriceTracker.Product
  import PriceTracker.Factory

  @valid_scenario_1 %{
    company_code: "ACME",
    product_name: "bclipsh chair",
    external_product_id: "2",
    price: 2000
  }

  @invalid_scenario_1 %{
  
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PriceTracker.Repo)
  end

  describe "Product model" do
    test "it must be invalid without a name, price and external id" do
      changeset = Product.changeset(%Product{}, @invalid_scenario_1)
      assert changeset.valid? == false
    end

    test "valid with a name, price and external id" do
      changeset = Product.changeset(build(:product))
      assert changeset.valid? == true
    end

  end
end
