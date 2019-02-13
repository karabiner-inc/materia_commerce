defmodule MateriaCommerce.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :item_code, :string
      add :description, :text
      add :unit_price, :decimal
      add :purchase_amount, :decimal
      add :merchandise_cost, :decimal
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :lock_version, :bigint

      timestamps()
    end

    create index(:prices, [:item_code])
  end
end
