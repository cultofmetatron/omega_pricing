defmodule PriceTracker.Repo.Migrations.CreateProductsAndPriceLog do
  use Ecto.Migration

  def change do
    #create the products
    create table(:products) do
      add :product_name, :string
      #not all external sources use autoinc
      add :external_product_id, :string
      add :price, :integer
      timestamps()
    end

    #create pricelog
    create table(:past_price_records) do
      add :product_id, references(:products)
      add :price, :integer
      add :percentage_change, :float
      timestamps()
    end


  end
end
