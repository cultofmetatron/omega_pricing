defmodule PriceTracker.PastPriceRecord do
  use PriceTracker.Headers, :model

  schema "past_price_record" do
    field :price, :integer
    field :percentage_change, :float
    belongs_to :product, PriceTracker.Product
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:price, :percentage_change])
      |> validate_required([:price, :percentage_change, :product])
  end

end
