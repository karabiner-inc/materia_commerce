defmodule MateriaCommerce.Repo.Migrations.AlterDeliveries do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add(:request_relation_number, :string)
      add(:request_abbreviated, :string)
    end
  end
end
