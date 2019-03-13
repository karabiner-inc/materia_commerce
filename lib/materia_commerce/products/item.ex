defmodule MateriaCommerce.Products.Item do
  use Ecto.Schema
  import Ecto.Changeset


  schema "items" do
    field :category1, :string
    field :category2, :string
    field :category3, :string
    field :category4, :string
    field :color, :string
    field :delivery_area, :string
    field :description, :string
    field :end_datetime, :utc_datetime
    field :image_url, :string
    field :item_code, :string
    field :jan_code, :string
    field :manufacturer, :string
    field :model_number, :string
    field :name, :string
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
    field :status, :integer, default: 1
    field :lock_version, :integer, default: 0

    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def create_changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :delivery_area, :manufacturer, :status, :color, :description, :start_datetime, :end_datetime, :tax_category, :lock_version, :inserted_id])
    |> validate_required([:name, :item_code, :start_datetime, :end_datetime, :lock_version, :inserted_id])
  end

  @doc false
  def update_changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :category1, :category2, :category3, :category4, :item_code, :model_number, :jan_code, :thumbnail, :image_url, :size1, :size2, :size3, :size4, :weight1, :weight2, :weight3, :weight4, :delivery_area, :manufacturer, :status, :color, :description, :start_datetime, :end_datetime, :tax_category, :lock_version, :inserted_id])
    |> validate_required([:lock_version, :inserted_id])
  end
end
