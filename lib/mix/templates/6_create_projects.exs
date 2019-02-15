defmodule MateriaCommerce.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :project_key1, :string
      add :project_key2, :string
      add :project_key3, :string
      add :project_key4, :string
      add :project_number, :string
      add :project_name, :string
      add :accuracy, :string
      add :project_date1, :utc_datetime
      add :project_date2, :utc_datetime
      add :project_date3, :utc_datetime
      add :project_date4, :utc_datetime
      add :project_date5, :utc_datetime
      add :project_date6, :utc_datetime
      add :quantity1, :integer
      add :quantity2, :integer
      add :quantity3, :integer
      add :quantity4, :integer
      add :quantity5, :integer
      add :quantity6, :integer
      add :description, :text
      add :note1, :text
      add :note2, :text
      add :note3, :text
      add :note4, :text
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :status, :integer
      add :lock_version, :bigint
      add :user_id, references(:users, on_delete: :nothing)
      add :inserted_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:projects, [:project_key1])
    create index(:projects, [:project_key2])
    create index(:projects, [:project_key3])
    create index(:projects, [:project_key4])
    create index(:projects, [:project_number])
    create index(:projects, [:status])
    create index(:projects, [:user_id])
    create index(:projects, [:inserted_id])
  end
end
