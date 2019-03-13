defmodule MateriaCommerce.Repo.Migrations.CreateContractDetails do
  use Ecto.Migration

  def change do
    create table(:contract_details) do
      add :contract_name, :string
      add :contract_no, :string
      add :amount, :integer
      add :price, :decimal
      add :purchase_amount, :decimal
      add :merchandise_cost, :decimal
      add :description, :text
      add :name, :string
      add :category1, :string
      add :category2, :string
      add :category3, :string
      add :category4, :string
      add :item_code, :string
      add :model_number, :string
      add :jan_code, :string
      add :thumbnail, :string
      add :image_url, :string
      add :size1, :string
      add :size2, :string
      add :size3, :string
      add :size4, :string
      add :weight1, :string
      add :weight2, :string
      add :weight3, :string
      add :weight4, :string
      add :delivery_area, :string
      add :manufacturer, :string
      add :color, :string
      add :tax_category, :string
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :lock_version, :bigint
      add :inserted_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:contract_details, [:contract_no])
    create index(:contract_details, [:item_code])
    create index(:contract_details, [:inserted_id])
  end
end
