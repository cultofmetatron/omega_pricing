defmodule PriceTracker.Strategy do
  @moduledoc """
    use this strategy to generate the make_request() function

    use PriceTracker.Strategy
    define these methods
      on_request() - returns a object containing info for how to access the api
      onReply(body) - passes in the response, we then process and return the paramaters for a product
  """

  def methods do
    quote do

      alias PriceTracker.Transactor
      import Logger
      
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
            HTTPoison.get(url, headers, options)
              |> process_response()
        end

      end

      # todo: handle error
      def process_response({:error, value}) when is_bitstring(value) or is_atom(value) do
        Logger.error value
      end

      def process_response({:error, value}) do
        Logger.error fn -> { "unknown error", [metadata: value] } end
      end

      def process_response({:ok, %{body: body}}) do
        products = on_reply(body)
        #place these into the transaction engine
        Transactor.merge_products(products, PriceTracker.Repo)
      end


    end
  end

  defmacro __using__(_) do
    apply(__MODULE__, :methods, [])
  end
  
end
