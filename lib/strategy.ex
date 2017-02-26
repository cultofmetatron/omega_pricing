defmodule PriceTracker.Strategy do
  @moduledoc """
    use this strategy to set how the request object should
    form the request to the api.

    use PriceTracker.Strategy
    define these methods
      request() - returns a object containing info for how to access the api
      onReply() - passes in the response, we then process and return the paramaters for a product

    Exposes the following methods on the strategy that can be used by a requester
    exacute()
  """

  def methods() do
    quote do
      def make_request() do
        %{method, url} = props = on_request()

      end

    end
  end

  defmacro __using__(_) do
    
  end
  
end
