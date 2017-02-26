defmodule PriceTracker.Repo.Migrations.AddCompanyCodeToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :company_code, :string, null: false
    end

    create index(:products, :company_code)
    create unique_index(:products, [:company_code, :external_product_id])
  end
end
