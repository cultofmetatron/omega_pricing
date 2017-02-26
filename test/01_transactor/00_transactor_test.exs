defmodule PriceTracker.TransactorTest do
  use ExUnit.Case
  #doctest PriceTracker
  alias PriceTracker.Repo
  alias PriceTracker.Product
  import PriceTracker.Factory
  alias PriceTracker.Transactor

  describe "Transactor.merge_product" do
    @docp """
      insert one product that doesn't exist should
      return a tuple {:ok, product } and we should be able t check the db
      for that product
    """
    test "inserts the product into the db and creates a price record when the product does not exist" do
      {:ok, product } = Transactor.merge_product(
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000
        }, Repo)
      
      stored_product = Enum.get(product, :id) |> Repo.get(Product) |> Repo.preload(:past_price_logs)
      assert stored_product != nil
    end

  end

  describe "Transactor.merge_products" do

    @docp """
      If you do not have a product with that external_product_id and the product is 
      not discontinued, create a new product record for it. Explicitly log that there 
      is a new product and that you are creating a new product.
    """
    test "if the product does not exist, it creates the product and pricelog" do
      {:ok, products } = Transactor.merge_products([
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000
        }
      ], Repo)
      assert Enum.count(products) == 1
      stored_product = Enum.get(products[0], :id) |> Repo.get(Product) |> Repo.preload(:past_price_logs)
      assert stored_product != nil

    end
  
    @docp """
      If you have a product with an external_product_id that matches their id and
      it has the same name and the price is different, create a new past price record 
      for your product. Then update the product's price. Do this even if the item is discontinued.
    """
    test "if the product exists, we attach the new price log and update the price" do
      
    end

    @docp """
      if you have a product record with a matching external_product_id 
      but a different product name, log an error message that warns the team that 
      there is a mismatch. Do not update the price.
    """
    test "" do

    end

  end

end
