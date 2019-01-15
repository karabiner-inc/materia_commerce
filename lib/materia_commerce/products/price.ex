defmodule MateriaCommerce.Products.Price do
  use Ecto.Schema
  import Ecto.Changeset


  schema "prices" do
    field :description, :string
    field :end_datetime, :utc_datetime
    field :lock_version, :integer, default: 0
    field :start_datetime, :utc_datetime
    field :unit_price, :decimal
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:description, :unit_price, :start_datetime, :end_datetime, :lock_version, :item_id])
    |> validate_required([:description, :unit_price, :start_datetime, :end_datetime, :lock_version])
  end

  @doc false
  def update_changeset(price, attrs) do
    price
    |> cast(attrs, [:description, :unit_price, :start_datetime, :end_datetime, :lock_version, :item_id])
    |> validate_required([:description, :unit_price, :start_datetime, :end_datetime, :lock_version])
    |> optimistic_lock(:lock_version)
  end
end
