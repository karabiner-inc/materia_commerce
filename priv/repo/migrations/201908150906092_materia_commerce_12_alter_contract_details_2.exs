defmodule MateriaCommerce.Repo.Migrations.AlterContractDetails2 do
  use Ecto.Migration

  def change do
    alter table(:contract_details) do
      add :delivery_id, references(:deliveries, on_delete: :nothing)
    end
  end
end
