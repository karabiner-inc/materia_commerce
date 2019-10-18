defmodule MateriaCommerce.Repo.Migrations.CreateDeliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :snd_zip_code, :string
      add :snd_address1, :string
      add :snd_address1_p, :string
      add :snd_address2, :string
      add :snd_address2_p, :string
      add :snd_address3, :string
      add :snd_address3_p, :string
      add :snd_phone_number, :string
      add :snd_fax_number, :string
      add :snd_notation_org_name, :string
      add :snd_notation_org_name_p, :string
      add :snd_notation_name, :string
      add :snd_notation_name_p, :string
      add :snd_date, :string
      add :snd_time, :string
      add :snd_condition1, :string
      add :snd_condition2, :string
      add :snd_condition3, :string
      add :snd_note1, :string
      add :snd_note2, :string
      add :snd_note3, :string
      add :rcv_zip_code, :string
      add :rcv_address1, :string
      add :rcv_address1_p, :string
      add :rcv_address2, :string
      add :rcv_address2_p, :string
      add :rcv_address3, :string
      add :rcv_address3_p, :string
      add :rcv_phone_number, :string
      add :rcv_fax_number, :string
      add :rcv_notation_org_name, :string
      add :rcv_notation_org_name_p, :string
      add :rcv_notation_name, :string
      add :rcv_notation_name_p, :string
      add :rcv_date, :string
      add :rcv_time, :string
      add :rcv_condition1, :string
      add :rcv_condition2, :string
      add :rcv_condition3, :string
      add :rcv_note1, :string
      add :rcv_note2, :string
      add :rcv_note3, :string
      add :clt_zip_code, :string
      add :clt_address1, :string
      add :clt_address1_p, :string
      add :clt_address2, :string
      add :clt_address2_p, :string
      add :clt_address3, :string
      add :clt_address3_p, :string
      add :clt_phone_number, :string
      add :clt_fax_number, :string
      add :clt_notation_org_name, :string
      add :clt_notation_org_name_p, :string
      add :clt_notation_name, :string
      add :clt_notation_name_p, :string
      add :lock_version, :bigint
      add :status, :integer
      add :snd_user_id, references(:users, on_delete: :nothing)
      add :rcv_user_id, references(:users, on_delete: :nothing)
      add :clt_user_id, references(:users, on_delete: :nothing)
      add :inserted_id, references(:users, on_delete: :nothing)
      add :updated_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:deliveries, [:snd_user_id])
    create index(:deliveries, [:rcv_user_id])
    create index(:deliveries, [:clt_user_id])
    create index(:deliveries, [:inserted_id])
    create index(:deliveries, [:updated_id])
  end
end
