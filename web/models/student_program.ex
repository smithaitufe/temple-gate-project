defmodule PortalApi.StudentProgram do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_programs" do
    belongs_to :student, PortalApi.Student
    belongs_to :program, PortalApi.Program
    belongs_to :department, PortalApi.Department
    belongs_to :level, PortalApi.Level
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(student_id program_id department_id level_id academic_session_id)a
  @optional_fields ~w()a

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
