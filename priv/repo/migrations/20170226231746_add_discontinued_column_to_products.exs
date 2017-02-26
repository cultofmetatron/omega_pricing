defmodule PriceTracker.Repo.Migrations.AddDiscontinuedColumnToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :discontinued, :boolean, default: false
    end
  end
end
