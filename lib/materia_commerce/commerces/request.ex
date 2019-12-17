defmodule MateriaCommerce.Commerces.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field(:accuracy, :string)
    field(:description, :string)
    field(:end_datetime, :utc_datetime)
    field(:lock_version, :integer, default: 0)
    field(:note1, :string)
    field(:note2, :string)
    field(:note3, :string)
    field(:note4, :string)
    field(:quantity1, :integer)
    field(:quantity2, :integer)
    field(:quantity3, :integer)
    field(:quantity4, :integer)
    field(:quantity5, :integer)
    field(:quantity6, :integer)
    field(:request_date1, :utc_datetime)
    field(:request_date2, :utc_datetime)
    field(:request_date3, :utc_datetime)
    field(:request_date4, :utc_datetime)
    field(:request_date5, :utc_datetime)
    field(:request_date6, :utc_datetime)
    field(:request_key1, :string)
    field(:request_key2, :string)
    field(:request_key3, :string)
    field(:request_key4, :string)
    field(:request_key5, :string)
    field(:request_name, :string)
    field(:request_number, :string)
    field(:start_datetime, :utc_datetime)
    field(:status, :integer, default: 0)
    field(:request_relation_number, :string)
    field(:request_abbreviated, :string)

    belongs_to(:user, Materia.Accounts.User)
    belongs_to(:inserted, Materia.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [
      :request_key1,
      :request_key2,
      :request_key3,
      :request_key4,
      :request_key5,
      :request_number,
      :request_name,
      :accuracy,
      :request_date1,
      :request_date2,
      :request_date3,
      :request_date4,
      :request_date5,
      :request_date6,
      :quantity1,
      :quantity2,
      :quantity3,
      :quantity4,
      :quantity5,
      :quantity6,
      :description,
      :note1,
      :note2,
      :note3,
      :note4,
      :start_datetime,
      :end_datetime,
      :status,
      :lock_version,
      :request_relation_number,
      :request_abbreviated,
      :user_id,
      :inserted_id
    ])
    |> validate_required([:request_number, :start_datetime, :end_datetime, :inserted_id])
  end
end
