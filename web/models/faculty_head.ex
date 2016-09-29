defmodule PortalApi.FacultyHead do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faculty_heads" do
    field :active, :boolean, default: false
    field :appointment_date, Ecto.Date
    field :effective_date, Ecto.Date
    field :end_date, :string
    belongs_to :faculty, PortalApi.Faculty
    belongs_to :staff, PortalApi.Staff

    timestamps
  end

  @required_fields ~w(staff_id faculty_id appointment_date effective_date end_date)a
  @optional_fields ~w(active)a

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
end
