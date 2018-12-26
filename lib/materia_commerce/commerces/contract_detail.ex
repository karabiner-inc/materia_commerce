defmodule MateriaCommerce.Commerces.ContractDetail do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contract_details" do
    field :amount, :integer
    field :category1, :string
    field :category2, :string
    field :category3, :string
    field :category4, :string
    field :color, :string
    field :contract_name, :string
    field :delivery_area, :string
    field :description, :string
    field :image_url, :string
    field :item_code, :string
    field :jan_code, :string
    field :lock_version, :integer, default: 0
    field :manufacturer, :string
    field :model_number, :string
    field :name, :string
    field :price, :integer
    field :size1, :string
    field :size2, :string
    field :size3, :string
    field :size4, :string
    field :tax_category, :string
    field :thumbnail, :string
    field :weight1, :string
    field :weight2, :string
    field :weight3, :string
    field :weight4, :string
    field :contract_id, :id
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(contract_detail, attrs) do
    contract_detail
    |> cast(attrs, [:contract_name, :amount, :price, :description, :name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :delivery_area, :manufacturer, :color, :tax_category, :item_id, :contract_id, :lock_version])
    |> validate_required([:contract_id])
  end

  @doc false
  def update_changeset(contract_detail, attrs) do
    contract_detail
    |> cast(attrs, [:contract_name, :amount, :price, :description, :name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :delivery_area, :manufacturer, :color, :tax_category, :item_id, :contract_id, :lock_version])
    |> validate_required([:lock_version])
    |> optimistic_lock(:lock_version)
  end
end
