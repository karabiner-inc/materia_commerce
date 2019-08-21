defmodule MateriaCommerce.Deliveries.Delivery do
  use Ecto.Schema
  import Ecto.Changeset


  schema "deliveries" do
    field :snd_phone_number, :string
    field :rcv_note3, :string
    field :snd_address2, :string
    field :rcv_address1_p, :string
    field :rcv_note1, :string
    field :clt_address3_p, :string
    field :clt_fax_number, :string
    field :rcv_condition2, :string
    field :rcv_condition1, :string
    field :clt_notation_org_name, :string
    field :clt_address1, :string
    field :rcv_address2_p, :string
    field :rcv_address3, :string
    field :snd_address3, :string
    field :snd_condition3, :string
    field :clt_address2_p, :string
    field :snd_address3_p, :string
    field :snd_notation_org_name_p, :string
    field :clt_address1_p, :string
    field :rcv_address3_p, :string
    field :rcv_fax_number, :string
    field :snd_note3, :string
    field :rcv_condition3, :string
    field :rcv_zip_code, :string
    field :rcv_notation_name_p, :string
    field :snd_address1, :string
    field :snd_condition1, :string
    field :rcv_notation_org_name, :string
    field :rcv_address1, :string
    field :clt_phone_number, :string
    field :clt_address3, :string
    field :lock_version, :integer, default: 0
    field :rcv_address2, :string
    field :rcv_date, :string
    field :snd_note2, :string
    field :rcv_time, :string
    field :snd_notation_name, :string
    field :rcv_note2, :string
    field :clt_notation_org_name_p, :string
    field :snd_fax_number, :string
    field :rcv_phone_number, :string
    field :snd_notation_name_p, :string
    field :snd_zip_code, :string
    field :snd_address1_p, :string
    field :snd_time, :string
    field :rcv_notation_org_name_p, :string
    field :snd_notation_org_name, :string
    field :clt_notation_name, :string
    field :snd_date, :string
    field :clt_address2, :string
    field :snd_condition2, :string
    field :clt_notation_name_p, :string
    field :clt_zip_code, :string
    field :rcv_notation_name, :string
    field :snd_note1, :string
    field :snd_address2_p, :string
    field :status, :integer, default: 1
    belongs_to :snd_user, Materia.Accounts.User
    belongs_to :rcv_user, Materia.Accounts.User
    belongs_to :clt_user, Materia.Accounts.User
    belongs_to :inserted, Materia.Accounts.User
    belongs_to :updated, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:snd_zip_code, :snd_address1, :snd_address1_p, :snd_address2, :snd_address2_p, :snd_address3, :snd_address3_p, :snd_phone_number, :snd_fax_number, :snd_notation_org_name, :snd_notation_org_name_p, :snd_notation_name, :snd_notation_name_p, :snd_date, :snd_time, :snd_condition1, :snd_condition2, :snd_condition3, :snd_note1, :snd_note2, :snd_note3, :rcv_zip_code, :rcv_address1, :rcv_address1_p, :rcv_address2, :rcv_address2_p, :rcv_address3, :rcv_address3_p, :rcv_phone_number, :rcv_fax_number, :rcv_notation_org_name, :rcv_notation_org_name_p, :rcv_notation_name, :rcv_notation_name_p, :rcv_date, :rcv_time, :rcv_condition1, :rcv_condition2, :rcv_condition3, :rcv_note1, :rcv_note2, :rcv_note3, :clt_zip_code, :clt_address1, :clt_address1_p, :clt_address2, :clt_address2_p, :clt_address3, :clt_address3_p, :clt_phone_number, :clt_fax_number, :clt_notation_org_name, :clt_notation_org_name_p, :clt_notation_name, :clt_notation_name_p, :lock_version, :status, :snd_user_id, :rcv_user_id, :clt_user_id, :inserted_id, :updated_id])
    |> validate_required([:inserted_id, :updated_id])
  end

  @doc false
  def update_changeset(delivery, attrs) do
    delivery
    |> cast(attrs, [:snd_zip_code, :snd_address1, :snd_address1_p, :snd_address2, :snd_address2_p, :snd_address3, :snd_address3_p, :snd_phone_number, :snd_fax_number, :snd_notation_org_name, :snd_notation_org_name_p, :snd_notation_name, :snd_notation_name_p, :snd_date, :snd_time, :snd_condition1, :snd_condition2, :snd_condition3, :snd_note1, :snd_note2, :snd_note3, :rcv_zip_code, :rcv_address1, :rcv_address1_p, :rcv_address2, :rcv_address2_p, :rcv_address3, :rcv_address3_p, :rcv_phone_number, :rcv_fax_number, :rcv_notation_org_name, :rcv_notation_org_name_p, :rcv_notation_name, :rcv_notation_name_p, :rcv_date, :rcv_time, :rcv_condition1, :rcv_condition2, :rcv_condition3, :rcv_note1, :rcv_note2, :rcv_note3, :clt_zip_code, :clt_address1, :clt_address1_p, :clt_address2, :clt_address2_p, :clt_address3, :clt_address3_p, :clt_phone_number, :clt_fax_number, :clt_notation_org_name, :clt_notation_org_name_p, :clt_notation_name, :clt_notation_name_p, :lock_version, :status, :snd_user_id, :rcv_user_id, :clt_user_id, :inserted_id, :updated_id])
    |> validate_required([:lock_version, :updated_id])
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      un_shipping: 0, #未発送
      shipping: 1, #発送済
      cancel: 9, #キャンセル
    }
  end
end
