defmodule MateriaCommerce.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add(:request_key1, :string)
      add(:request_key2, :string)
      add(:request_key3, :string)
      add(:request_key4, :string)
      add(:request_key5, :string)
      add(:request_number, :string)
      add(:request_name, :string)
      add(:accuracy, :string)
      add(:request_date1, :utc_datetime)
      add(:request_date2, :utc_datetime)
      add(:request_date3, :utc_datetime)
      add(:request_date4, :utc_datetime)
      add(:request_date5, :utc_datetime)
      add(:request_date6, :utc_datetime)
      add(:quantity1, :integer)
      add(:quantity2, :integer)
      add(:quantity3, :integer)
      add(:quantity4, :integer)
      add(:quantity5, :integer)
      add(:quantity6, :integer)
      add(:description, :text)
      add(:note1, :text)
      add(:note2, :text)
      add(:note3, :text)
      add(:note4, :text)
      add(:start_datetime, :utc_datetime)
      add(:end_datetime, :utc_datetime)
      add(:status, :integer)
      add(:lock_version, :bigint)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:inserted_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:requests, [:request_key1]))
    create(index(:requests, [:request_key2]))
    create(index(:requests, [:request_key3]))
    create(index(:requests, [:request_key4]))
    create(index(:requests, [:request_key5]))
    create(index(:requests, [:request_number]))
    create(index(:requests, [:status]))
    create(index(:requests, [:user_id]))
    create(index(:requests, [:inserted_id]))
  end
end
