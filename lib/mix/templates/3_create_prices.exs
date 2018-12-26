defmodule MateriaCommerce.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :description, :text
      add :unit_price, :decimal
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :lock_version, :bigint
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:prices, [:item_id])
  end
end