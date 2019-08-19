defmodule MateriaCommerce.Repo.Migrations.AlterContracts2 do
  use Ecto.Migration

  def change do
    alter table(:contracts) do
      add :total_size, :decimal
      add :total_weight, :decimal
      add :total_count, :decimal
      add :billing_amount, :decimal
      add :other_fee, :decimal
      add :contract_name, :string
      add :description, :text
      add :note1, :text
      add :note2, :text
      add :note3, :text
      add :note4, :text
      add :delivery_id, references(:deliveries, on_delete: :nothing)
    end
  end
end
