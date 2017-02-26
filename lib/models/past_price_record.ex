defmodule PriceTracker.PastPriceRecord do
  use Ecto.Schema

  schema "past_price_record" do
    field :price, :integer
    field :percentage_change, :float
    belongs_to :product, PriceTracker.Product
    timestamps()
  end

end
