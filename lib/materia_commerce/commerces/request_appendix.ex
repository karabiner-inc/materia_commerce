defmodule MateriaCommerce.Commerces.RequestAppendix do
  use Ecto.Schema
  import Ecto.Changeset


  schema "request_appendices" do
    field :appendix_category, :string
    field :appendix_date, :utc_datetime
    field :appendix_description, :string
    field :appendix_name, :string
    field :appendix_number, :decimal
    field :appendix_status, :integer
    field :end_datetime, :utc_datetime
    field :lock_version, :integer, default: 0
    field :request_key1, :string
    field :request_key2, :string
    field :request_key3, :string
    field :request_key4, :string
    field :request_number, :string
    field :start_datetime, :utc_datetime

    belongs_to :inserted, Materia.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(request_appendix, attrs) do
    request_appendix
    |> cast(attrs, [:request_key1, :request_key2, :request_key3, :request_key4, :request_number, :appendix_category, :appendix_name, :appendix_date, :appendix_number, :appendix_description, :appendix_status, :start_datetime, :end_datetime, :lock_version, :inserted_id])
    |> validate_required([:request_number, :start_datetime, :end_datetime, :inserted_id])
  end
end
