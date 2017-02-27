defmodule PriceTracker.TransactorTest do
  use ExUnit.Case
  #doctest PriceTracker
  
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PriceTracker.Repo)
  end

  alias PriceTracker.Repo
  alias PriceTracker.Product
  import PriceTracker.Factory
  alias PriceTracker.Transactor
  import Ecto.Query


  describe "Transactor.merge_product" do
    @docp """
      [x] If you do not have a product with that external_product_id and the product is
          not discontinued, create a new product record for it.
      
      [ ] Explicitly log that there is a new product and that you are creating
          a new product.
    """
    test "inserts the product into the db and creates a price record when the product does not exist" do
      {:ok, :created, product } = Transactor.merge_product(
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000
        }, Repo)
      
      stored_product = Repo.get(Product, Map.get(product, :id))
        |> Repo.preload(:past_price_records)
      assert stored_product != nil
      assert stored_product.company_code == product.company_code
      assert Enum.count(stored_product.past_price_records) == 1
    end

    test "skips creation if discontinued" do
      assert {:skip, :discontinued} = Transactor.merge_product(
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000,
          discontinued: true
        }, Repo)
    end

    @docp """
      [x] if you have a product record with a matching external_product_id
          but a different product name, log an error message that warns the team that
          there is a mismatch. Do not update the price.
    """
    test "returns error if the name has changed for the product" do
      {:ok, :created, product } = Transactor.merge_product(
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000
        }, Repo)
      id = product.id
      assert {:error, :name_for_product_changed, %{ id: ^id  } } = Transactor.merge_product(
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 7",
          price: 30000
        }, Repo)

      #price should not be changed in the database
      assert Repo.get(Product, product.id).price == 50000
    end


    @docp """
      [x] If you have a product with an external_product_id that matches their id and
          it has the same name and the price is different, create a new past price record 
          for your product. Then update the product's price. 
          Do this even if the item is discontinued.
    """
    test "if the product exists, we attach the new price log and update the price" do
      {:ok, :created, product_1 } = Transactor.merge_product(%{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 50000
      }, Repo)
    
      {:ok, :updated, product_2 } = Transactor.merge_product(%{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 20000
      }, Repo)
    
      # product ids should be the same
      assert product_1.id == product_2.id

      # it should now have two records
      assert Enum.count(product_2.past_price_records) == 2

      {:ok, :updated, product_3 } = Transactor.merge_product(%{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 30000
      }, Repo)

      assert Enum.count(product_3.past_price_records) == 3
    end

  end

  describe "Transactor.merge_products" do
    test "Transactor merges one product" do
      Transactor.merge_products([
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 30000
        }
      ], Repo)

      product = from(p in Product)
        |> where([p], p.company_code == "ACME" and p.external_product_id == "5323")
        |> Repo.one()
      assert %Product{id: id} = product

    end

    test "Transactor merges 3 products" do
      Transactor.merge_products([
        %{
          company_code: "ACME",
          external_product_id: "5323",
          product_name: "acme chair no 5",
          price: 30000
        },
        %{
          company_code: "ACME",
          external_product_id: "3235",
          product_name: "acme chair no 7",
          price: 30000
        },
        %{
          company_code: "ACME",
          external_product_id: "5325",
          product_name: "acme chair no 8",
          price: 30000
        }
      ], Repo)

    end

  end

end
