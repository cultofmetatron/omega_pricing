defmodule PriceTracker.PastPriceRecord do
  use PriceTracker.Headers, :model

  schema "past_price_records" do
    field :price, :integer
    field :percentage_change, :float
    belongs_to :product, PriceTracker.Product
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:price, :percentage_change, :product_id])
      |> cast_assoc(:product)
      |> assoc_constraint(:product)
      |> validate_required([:price, :percentage_change])
  end

end
