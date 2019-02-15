defmodule MateriaCommerce.Repo.Migrations.CreateProjectAppendices do
  use Ecto.Migration

  def change do
    create table(:project_appendices) do
      add :project_key1, :string
      add :project_key2, :string
      add :project_key3, :string
      add :project_key4, :string
      add :project_number, :string
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

    create index(:project_appendices, [:project_key1])
    create index(:project_appendices, [:project_key2])
    create index(:project_appendices, [:project_key3])
    create index(:project_appendices, [:project_key4])
    create index(:project_appendices, [:project_number])
    create index(:project_appendices, [:appendix_category])
    create index(:project_appendices, [:inserted_id])
  end
end
