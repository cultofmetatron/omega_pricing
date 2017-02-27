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

  def methods do
    quote do
      def make_request() do
        props = on_request()
        
        url = if props.query_params do
          props.url <> "&" <> URI.encode_query(props.query_params)
        else
          props.url
        end

        headers = if Map.get(props, :headers), do: props.headers, else: []
        options = if Map.get(props, :options), do: props.options, else: []
        # only support get method but it might be useful.
        # adding the case to make it easier to refactor later
        response = case props.method do
          :get ->
            IO.puts("########")
            IO.puts(url)
            HTTPoison.get(url, headers, options)
              |> process_response()
        end

      end

      # todo: handle error
      def process_response({:error, value}) do

      end

      def process_response({:ok, %{body: body}}) do
        products = on_reply(body)
        IO.inspect(products)
        products
      end


    end
  end

  defmacro __using__(_) do
    apply(__MODULE__, :methods, [])
  end
  
end
