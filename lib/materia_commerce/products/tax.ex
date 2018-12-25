defmodule MateriaCommerce.Products.Tax do
  use Ecto.Schema
  import Ecto.Changeset


  schema "taxes" do
    field :end_datetime, :utc_datetime
    field :lock_version, :integer, default: 0
    field :name, :string
    field :start_datetime, :utc_datetime
    field :tax_category, :string
    field :tax_rate, :decimal

    timestamps()
  end

  @doc false
  def changeset(tax, attrs) do
    tax
    |> cast(attrs, [:name, :tax_category, :tax_rate, :start_datetime, :end_datetime, :lock_version])
    |> validate_required([:name, :tax_category, :tax_rate, :start_datetime, :end_datetime, :lock_version])
  end

  @doc false
  def update_changeset(tax, attrs) do
    tax
    |> cast(attrs, [:name, :tax_category, :tax_rate, :start_datetime, :end_datetime, :lock_version])
    |> validate_required([:name, :tax_category, :tax_rate, :start_datetime, :end_datetime, :lock_version])
    |> optimistic_lock(:lock_version)
  end
end
