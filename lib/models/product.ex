defmodule PriceTracker.Product do
  use PriceTracker.Headers, :model


  schema "products" do
    field :company_code, :string
    field :product_name, :string
    field :external_product_id, :string
    field :price, :integer
    field :discontinued, :boolean, default: false

    has_many :past_price_records, PriceTracker.PastPriceRecord
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:company_code, :product_name, :external_product_id, :price, :discontinued])
      |> validate_required([:company_code, :product_name, :external_product_id, :price])
      |> validate_number(:price, greater_than_or_equal_to: 0)
      |> validate_length(:product_name, min: 2)
  end

end
