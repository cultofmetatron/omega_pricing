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

  describe "Price record model" do
    test "valid if if has all proper attrs and associations" do
      assert PastPriceRecord.changeset(build(:past_price_record)).valid? == true
    end
  end

end
