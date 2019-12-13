defmodule MateriaCommerce.Repo.Migrations.AlterContractDetails do
  use Ecto.Migration

  def change do
    alter table(:contract_details) do
      add(:delivery_id, references(:deliveries, on_delete: :nothing))
    end

    create(index(:contract_details, [:delivery_id, :start_datetime, :end_datetime]))
  end
end
