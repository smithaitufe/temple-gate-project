defmodule PortalApi.StudentDirectEntryQualification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_direct_entry_qualifications" do
    field :school, :string
    field :course_studied, :string
    field :cgpa, :float
    field :year_admitted, :integer
    field :year_graduated, :integer
    field :verified, :boolean, default: false
    field :verified_at, Ecto.DateTime
    belongs_to :student, PortalApi.Student
    belongs_to :verified_by, PortalApi.Staff, foreign_key: :verified_by_staff_id

    timestamps
  end

  @required_fields ~w(school course_studied cgpa year_admitted year_graduated)a
  @optional_fields ~w(verified verified_at verified_by_staff_id)a

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
