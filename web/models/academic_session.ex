defmodule PortalApi.AcademicSession do
  use PortalApi.Web, :model

  schema "academic_sessions" do
    field :description, :string
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    field :active, :boolean, default: true

    timestamps
  end

  @required_fields [:description, :opening_date, :closing_date, :active]
  @optional_fields []

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def active(query) do
    query
    |> where([query], query.active == true)    
  end
  def sorted(query, field) do
    query
    |> order_by([query], [asc: ^String.to_existing_atom(field)])
  end
 
end
