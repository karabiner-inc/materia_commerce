defmodule MateriaCommerce.Repo.Migrations.AlterDeliveries do
  use Ecto.Migration

  def change do
    alter table(:deliveries) do
      add(:snd_area_code, :string)
      add(:rcv_area_code, :string)
      add(:clt_area_code, :string)
    end
  end
end
