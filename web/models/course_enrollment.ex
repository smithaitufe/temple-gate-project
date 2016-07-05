defmodule PortalApi.CourseEnrollment do
  use PortalApi.Web, :model

  schema "course_enrollments" do
    belongs_to :course, PortalApi.Course
    belongs_to :student, PortalApi.Student
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
