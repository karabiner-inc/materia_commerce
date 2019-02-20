defmodule MateriaCommerce.Repo.Migrations.CreateRequestAppendices do
  use Ecto.Migration

  def change do
    create table(:request_appendices) do
      add :request_key1, :string
      add :request_key2, :string
      add :request_key3, :string
      add :request_key4, :string
      add :request_number, :string
      add :appendix_category, :string
      add :appendix_name, :string
      add :appendix_date, :utc_datetime
      add :appendix_number, :decimal
      add :appendix_description, :text
      add :appendix_status, :integer
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :lock_version, :bigint
      add :inserted_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:request_appendices, [:request_key1])
    create index(:request_appendices, [:request_key2])
    create index(:request_appendices, [:request_key3])
    create index(:request_appendices, [:request_key4])
    create index(:request_appendices, [:request_number])
    create index(:request_appendices, [:appendix_category])
    create index(:request_appendices, [:inserted_id])
  end
end
