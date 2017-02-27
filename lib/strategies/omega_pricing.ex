defmodule PriceTracker.OmegaPricingStrategy do
  use PriceTracker.Strategy
  use Timex

  @company_code "OMEGA"

  @doc """
    called when we want to run this enque this query.
    it returns a set of paramaters that will be used by the requester
    to get the data.
  """
  def on_request() do
    %{
      method: :get,
      url: "https://omegapricinginc.com/pricing/records.json",
      query_params:  %{
        api_key: "abc123key",
        start_date: Timex.now |> Timex.shift(months: -1),
        end_date: Timex.today 
      },
      headers: %{}
    }
  end

  @doc """
    the requester passes the data to the on_reply where
    we can clean up the parsed messaeg into the pattern that 
    the model will accept.

    the requester then takes control of merging the data into the database

    [product]
    where product is 
    %{
      company_code: @company_code,
      product_name: string,
      external_product_id: string,
      price: integer
    }
  """
  def on_reply(body) do
    body
      |> Map.get("productRecords")
      |> Enum.map(&transform_product_body/1)
  end

  defp transform_product_body(product) do
   %{
      company_code: "OMEGA",
      product_name: Map.get(product, "name"),
      external_product_id: "#{Map.get(product, "id")}" ,
      price: Map.get(product, "price") |> process_price(),
      discontinued: Map.get(product, "discontinued")
    }
  end

  @docp """
    converts the price to integer in pennies
    we can chop off the '$' and . then parse for int
  """
  def process_price("$" <> price), do: process_price(price)
  def process_price(price) do
    {price, _} = price
                |> String.split(".")
                |> Enum.join("")
                |> Integer.parse(10)
    price
  end

end
