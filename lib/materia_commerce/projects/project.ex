defmodule MateriaCommerce.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset


  schema "projects" do
    field :accuracy, :string
    field :description, :string
    field :end_datetime, :utc_datetime
    field :lock_version, :integer, default: 0
    field :note1, :string
    field :note2, :string
    field :note3, :string
    field :note4, :string
    field :project_date1, :utc_datetime
    field :project_date2, :utc_datetime
    field :project_date3, :utc_datetime
    field :project_date4, :utc_datetime
    field :project_date5, :utc_datetime
    field :project_date6, :utc_datetime
    field :project_key1, :string
    field :project_key2, :string
    field :project_key3, :string
    field :project_key4, :string
    field :project_name, :string
    field :project_number, :string
    field :quantity1, :integer
    field :quantity2, :integer
    field :quantity3, :integer
    field :quantity4, :integer
    field :quantity5, :integer
    field :quantity6, :integer
    field :start_datetime, :utc_datetime
    field :status, :integer, default: 0

    belongs_to :user, Materia.Accounts.User
    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:project_key1, :project_key2, :project_key3, :project_key4, :project_number, :project_name, :accuracy, :project_date1, :project_date2, :project_date3, :project_date4, :project_date5, :project_date6, :quantity1, :quantity2, :quantity3, :quantity4, :quantity5, :quantity6, :description, :note1, :note2, :note3, :note4, :start_datetime, :end_datetime, :status, :lock_version, :user_id, :inserted_id])
    |> validate_required([:project_number, :start_datetime, :end_datetime, :inserted_id])
  end
end
