defmodule MateriaCommerce.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :contract_no, :string
      add :settlement, :string
      add :seller_id, :integer
      add :buyer_id, :integer
      add :delivery_address, :integer
      add :delivery_start_datetime, :utc_datetime
      add :delivery_end_datetime, :utc_datetime
      add :billing_address, :integer
      add :sender_address, :integer
      add :shipping_fee, :decimal
      add :tax_amount, :decimal
      add :total_amount, :decimal
      add :status, :string
      add :expiration_date, :utc_datetime
      add :contracted_date, :utc_datetime
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :lock_version, :bigint

      timestamps()
    end

  end
end
