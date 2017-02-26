defmodule PriceTracker.Transactor do
  @moduledoc """
    Transactor is in charge of storing the params generated by
    the requester into the database.

  """
  use PriceTracker.Headers, :transactor
  alias PriceTracker.Product
  alias PriceTracker.PastPriceRecord

  def merge_products(products, repo) do
    
  end

  def merge_product(product, repo) do
    # find existing product with code and external product id
    case find_existing_product(product) |> Repo.one() do
      nil ->
        create_product(product, repo)
      %Product{}=product ->
        update_product(product, repo)
    end
  end

  defp create_product(product, repo) do
    
  end

  defp update_product(product, repo) do
    {:error, :not_implimented}
  end

  defp find_existing_product(product) do
    %{company_code: code, external_product_id: external_id} = product
    from(p in Product)
      |> where([p], p.company_code == ^code and p.external_product_id == ^external_id)
  end

end
