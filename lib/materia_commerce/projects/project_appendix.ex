defmodule MateriaCommerce.Projects.ProjectAppendix do
  use Ecto.Schema
  import Ecto.Changeset


  schema "project_appendices" do
    field :appendix_category, :string
    field :appendix_date, :utc_datetime
    field :appendix_description, :string
    field :appendix_name, :string
    field :appendix_number, :decimal
    field :appendix_status, :integer
    field :end_datetime, :utc_datetime
    field :lock_version, :integer, default: 0
    field :project_key1, :string
    field :project_key2, :string
    field :project_key3, :string
    field :project_key4, :string
    field :project_number, :string
    field :start_datetime, :utc_datetime

    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(project_appendix, attrs) do
    project_appendix
    |> cast(attrs, [:project_key1, :project_key2, :project_key3, :project_key4, :project_number, :appendix_category, :appendix_name, :appendix_date, :appendix_number, :appendix_description, :appendix_status, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:project_number, :start_datetime, :end_datetime, :inserted_id])
  end
end
