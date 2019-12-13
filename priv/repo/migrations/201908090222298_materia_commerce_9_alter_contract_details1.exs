defmodule MateriaCommerce.Repo.Migrations.AlterContractDetails do
  use Ecto.Migration

  def change do
    alter table(:contract_details) do
      add(:branch_type, :string)
      add(:branch_number, :integer)
    end
  end
end
