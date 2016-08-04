defmodule PortalApi.StudentProgram do
  use PortalApi.Web, :model

  schema "student_programs" do
    belongs_to :student, PortalApi.Student
    belongs_to :program, PortalApi.Program
    belongs_to :department, PortalApi.Department
    belongs_to :level, PortalApi.Level
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
