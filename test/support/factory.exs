defmodule PriceTracker.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: PriceTracker.Repo

  # without Ecto
  use ExMachina
  
  alias PriceTracker.Product
  alias PriceTracker.PastProductRecord
  
  def product_factory do
    %Product{
      company_code: sequence(:product_name, &"ACME_#{&1}"),
      product_name: sequence(:product_name, &"chair_#{&1}"),
      external_product_id: sequence(:external_product_id, &"#{&1}"),
      price: 2000
    }
  end

  def past_price_record_factory do
    %PastPriceRecord{
      price: sequence(:price, &(&1))
      percentage_change: 0,
      build(:product)
    }
  end

end
