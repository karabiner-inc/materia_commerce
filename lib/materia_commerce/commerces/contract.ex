defmodule MateriaCommerce.Commerces.Contract do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contracts" do
    field :request_number, :string
    field :billing_address, :integer
    #field :buyer_id, :integer
    field :contract_no, :string
    field :branch_type, :string, default: "contract"
    field :branch_number, :integer, default: 0
    field :contracted_date, :utc_datetime
    field :delivery_address, :integer
    field :delivery_end_datetime, :utc_datetime
    field :delivery_start_datetime, :utc_datetime
    field :end_datetime, :utc_datetime
    field :expiration_date, :utc_datetime
    field :lock_version, :integer, default: 0
    #field :seller_id, :integer
    field :sender_address, :integer
    field :settlement, :string
    field :shipping_fee, :decimal
    field :start_datetime, :utc_datetime
    field :status, :integer, default: 1
    field :tax_amount, :decimal
    field :total_amount, :decimal
    field :total_size, :decimal
    field :total_weight, :decimal
    field :total_count, :decimal
    field :billing_amount, :decimal
    field :other_fee, :decimal
    field :contract_name, :string
    field :description, :string
    field :note1, :string
    field :note2, :string
    field :note3, :string
    field :note4, :string

    belongs_to :buyer, Materia.Accounts.User
    belongs_to :seller,  Materia.Accounts.User
    belongs_to :inserted, Materia.Accounts.User
    belongs_to :delivery, MateriaCommerce.Deliveries.Delivery

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :branch_type, :branch_number, :request_number, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :start_datetime, :end_datetime, :lock_version, :inserted_id, :total_size, :total_weight, :total_count, :billing_amount, :other_fee, :contract_name, :description, :note1, :note2, :note3, :note4, :delivery_id])
    |> validate_required([:contract_no, :start_datetime, :end_datetime, :lock_version, :inserted_id])
  end

  def update_changeset(contract, attrs) do
    contract
    |> cast(attrs, [:contract_no, :branch_type, :branch_number, :request_number, :settlement, :seller_id, :buyer_id, :delivery_address, :delivery_start_datetime, :delivery_end_datetime, :billing_address, :sender_address, :shipping_fee, :tax_amount, :total_amount, :status, :expiration_date, :contracted_date, :start_datetime, :end_datetime, :lock_version, :inserted_id, :total_size, :total_weight, :total_count, :billing_amount, :other_fee, :contract_name, :description, :note1, :note2, :note3, :note4, :delivery_id])
    |> validate_required([:contract_no, :lock_version, :inserted_id])
  end
end
