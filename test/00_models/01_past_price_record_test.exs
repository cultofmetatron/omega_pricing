defmodule PriceTracker.PastPriceRecordTest do
  use ExUnit.Case
  #doctest PriceTracker
  alias PriceTracker.Product
  alias PriceTracker.PastPriceRecord
  import PriceTracker.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PriceTracker.Repo)
  end

  @invalid_scenario_1 %{
  }

  @invalid_scenario_2 %{
    price: 3000,
    percentage_change: 32.3
  }

  @invalid_scenario_3 %{
    product_id: build(:product).id
  }

  describe "Price record model" do
    test "invalid if it lacks a name, price or external_id" do
      product = Product.changeset(build :product)
      assert PastPriceRecord.changeset(%PastPriceRecord{}, @invalid_scenario_1).valid? == false
      assert PastPriceRecord.changeset(%PastPriceRecord{}, @invalid_scenario_3).valid? == false
    end

    test "invalid if it lacks a product reference" do
      product = Product.changeset(build :product)
      assert PastPriceRecord.changeset(%PastPriceRecord{}, @invalid_scenario_2).valid? == false
    end

    test "valid if if has all proper attrs and associations" do
      assert PastPriceRecord.changeset(build(:past_price_record)).valid? == true
    end
  end

end
