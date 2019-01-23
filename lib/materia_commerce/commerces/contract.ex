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
    field :end_datetime, :utc_datetime
    field :expiration_date, :utc_datetime
    field :lock_version, :integer, default: 0
    field :seller_id, :integer
    field :sender_address, :integer
    field :settlement, :string
    field :shipping_fee, :decimal
    field :start_datetime, :utc_datetime
    field :status, :integer, default: 1
    field :tax_amount, :decimal
    field :total_amount, :decimal

    has_many :contract_details, MateriaCommerce.Commerces.ContractDetail

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :start_datetime, :end_datetime, :lock_version])
    |> validate_required([:contract_no, :start_datetime, :end_datetime, :lock_version])
  end

  def update_changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :start_datetime, :end_datetime, :lock_version])
    |> validate_required([:contract_no, :lock_version])
  end
end
