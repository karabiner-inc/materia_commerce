defmodule MateriaCommerce.Commerces.ContractDetail do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contract_details" do
    field :contract_detail_no, :string
    field :amount, :integer
    field :category1, :string
    field :category2, :string
    field :category3, :string
    field :category4, :string
    field :color, :string
    field :contract_name, :string
    field :contract_no, :string
    field :delivery_area, :string
    field :description, :string
    field :end_datetime, :utc_datetime
    field :image_url, :string
    field :item_code, :string
    field :jan_code, :string
    field :lock_version, :integer, default: 0
    field :manufacturer, :string
    field :merchandise_cost, :decimal
    field :model_number, :string
    field :name, :string
    field :price, :decimal
    field :purchase_amount, :decimal
    field :size1, :string
    field :size2, :string
    field :size3, :string
    field :size4, :string
    field :start_datetime, :utc_datetime
    field :tax_category, :string
    field :thumbnail, :string
    field :weight1, :string
    field :weight2, :string
    field :weight3, :string
    field :weight4, :string
    field :datetime1, :utc_datetime
    field :datetime2, :utc_datetime
    field :datetime3, :utc_datetime
    field :datetime4, :utc_datetime

    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(contract_detail, attrs) do
    contract_detail
    |> cast(attrs, [:contract_detail_no, :contract_name, :contract_no, :amount, :price, :purchase_amount, :merchandise_cost, :description, :name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :datetime1, :datetime2, :datetime3, :datetime4, :delivery_area, :manufacturer, :color, :tax_category, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:contract_detail_no, :contract_no, :start_datetime, :end_datetime, :lock_version, :inserted_id])
  end

  @doc false
  def update_changeset(contract_detail, attrs) do
    contract_detail
    |> cast(attrs, [:contract_detail_no, :contract_name, :contract_no, :amount, :price, :purchase_amount, :merchandise_cost, :description, :name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :datetime1, :datetime2, :datetime3, :datetime4, :delivery_area, :manufacturer, :color, :tax_category, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:contract_detail_no, :lock_version, :inserted_id])
  end
end
