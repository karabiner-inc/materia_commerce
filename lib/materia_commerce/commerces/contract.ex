defmodule MateriaCommerce.Commerces.Contract do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contracts" do
    field :billing_address, :integer
    field :buyer_id, :integer
    field :contract_no, :string
    field :contracted_date, :utc_datetime
    field :delivery_address, :integer
    field :delivery_end_datetime, :utc_datetime
    field :delivery_start_datetime, :utc_datetime
    field :expiration_date, :utc_datetime
    field :lock_version, :integer, default: 0
    field :seller_id, :integer
    field :sender_address, :integer
    field :settlement, :string
    field :shipping_fee, :decimal
    field :status, :string
    field :tax_amount, :decimal
    field :total_amount, :decimal

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :lock_version])
    |> validate_required([:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :lock_version])
  end

  @doc false
  def update_changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :lock_version])
    |> validate_required([:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :lock_version])
    |> optimistic_lock(:lock_version)
  end
end
