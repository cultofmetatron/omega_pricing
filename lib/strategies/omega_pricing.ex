defmodule PriceTracker.OmegaPricingStrategy do
  use PriceTracker.Strategy
  use Timex

  @company_code "OMEGA"

  @doc """
    called when we want to run this enque this query.
    it returns a set of paramaters that will be used by the requester
    to get the data.
  """
  def request() do
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
    
  end

end
