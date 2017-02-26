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

  def merge_product(params, repo) do
    # find existing product with code and external product id
    case find_existing_product(params) |> repo.one() do
      nil ->
        create_product(params, repo)
      %Product{}=product ->
        update_product(product, params, repo)
    end
  end

  @docp """
    Takes a product and repo and creates the product in
    the system.

  """
  defp create_product(params, repo) do
    repo.transaction(fn() ->
      new_product = Product.changeset(%Product{}, params)
                    |> repo.insert!()
                    |> repo.preload([:past_price_records])
      new_past_price_record = build_assoc(new_product, :past_price_records)
      |> PastPriceRecord.changeset(%{
          price: new_product.price,
          percentage_change: 100 # new prices are a 100% change
        })
      |> repo.insert!()
      new_product |> repo.preload([:past_price_records], force: true) #return the new product
    end)
  end

  @docp """
    Takes a product and repo and updates the product in
    the system if the name has not changed

  """
  defp update_product(product, params, repo) do
    #{:error, :not_implimented}
    if name_changed?(product, params) do
      {:error, :name_for_product_changed}
    else
      repo.transaction(fn() ->
        # get the most recent price record
        product = product |> repo.preload([:past_price_records])
        # there's prolly a way to do this in the db but its a premature opt
        # at this point
        latest_record = product.past_price_records
          |> Enum.sort_by(fn(record) -> record.inserted_at end, &>=/2)
          |> Enum.at(0)

        # if this gets triggerred, something has messed with the database
        # in a way that voids the assumptions we make about the state
        # of the database. In such a case, it is prudent to raise an error
        # and stop operation till an engineer looks into it.
        if (latest_record.price !== product.price) do
          raise RuntimeError, message: "price record does not match current product"
        end

        #update the price
        product = Product.changeset(product, %{price: params.price}) |> repo.update!()
        build_assoc(product, :past_price_records)
          |> PastPriceRecord.changeset(%{
               price: product.price,
               percentage_change: (params.price - latest_record.price)/latest_record.price
             })
          |> repo.insert!()
        product |> repo.preload([:past_price_records], force: true)
      end)
    end
  end

  defp price_changed?(product, params), do: product.price != params.price
  defp name_changed?(product, params),  do: product.product_name != params.product_name

  defp find_existing_product(product) do
    %{company_code: code, external_product_id: external_id} = product
    from(p in Product)
      |> where([p], p.company_code == ^code and p.external_product_id == ^external_id)
  end

end
