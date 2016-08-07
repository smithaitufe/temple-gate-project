defmodule PortalApi.StudentResult do
  use PortalApi.Web, :model

  schema "student_results" do
    belongs_to :academic_session, PortalApi.AcademicSession
    belongs_to :student, PortalApi.Student
    belongs_to :level, PortalApi.Level
    belongs_to :semester, PortalApi.Term
    belongs_to :course, PortalApi.Course
    belongs_to :grade, PortalApi.Grade
    field :score, :float, default: 0.0

    timestamps
  end

  @required_fields ~w(academic_session_id student_id level_id semester_id course_id grade_id score)
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
