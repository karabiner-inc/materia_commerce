defmodule MateriaCommerce.Repo.Migrations.CreateTaxes do
  use Ecto.Migration

  def change do
    create table(:taxes) do
      add(:name, :string)
      add(:tax_category, :string)
      add(:tax_rate, :decimal)
      add(:start_datetime, :utc_datetime)
      add(:end_datetime, :utc_datetime)
      add(:lock_version, :bigint)
      add(:inserted_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:taxes, [:name]))
    create(index(:taxes, [:inserted_id]))
  end
end
