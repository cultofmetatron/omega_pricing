defmodule PriceTracker.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: MyApp.Repo

  # without Ecto
  use ExMachina

  def product_factory do
  end

  def past_price_record_factory do
  end

  def comment_factory do
  end
end
