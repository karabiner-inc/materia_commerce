defmodule MateriaCommerce.Repo.Migrations.AlterContracts1 do
  use Ecto.Migration

  def change do
    alter table(:contracts) do
      add :branch_type, :string
      add :branch_number, :integer
    end
  end
end
