defmodule MateriaCommerce.Products.Price do
  use Ecto.Schema
  import Ecto.Changeset


  schema "prices" do
    field :description, :string
    field :end_datetime, :utc_datetime
    field :item_code, :string
    field :lock_version, :integer, default: 0
    field :merchandise_cost, :decimal
    field :purchase_amount, :decimal
    field :start_datetime, :utc_datetime
    field :unit_price, :decimal

    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:item_code, :description, :unit_price, :purchase_amount, :merchandise_cost, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:item_code, :unit_price, :start_datetime, :end_datetime, :lock_version, :inserted_id])
  end

  @doc false
  def update_changeset(price, attrs) do
    price
    |> cast(attrs, [:item_code, :description, :unit_price, :purchase_amount, :merchandise_cost, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:item_code, :unit_price, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> optimistic_lock(:lock_version)
  end
end
