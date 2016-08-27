defmodule PortalApi.StudentCourseAssessment do
  use PortalApi.Web, :model

  schema "student_course_assessments" do
    field :score, :float
    field :active, :boolean, default: true
    belongs_to :student_course, PortalApi.StudentCourse
    belongs_to :staff, PortalApi.Staff
    belongs_to :assessment_type, PortalApi.Term, foreign_key: :assessment_type_id

    timestamps
  end

  @required_fields ~w(staff_id student_course_id assessment_type_id score)
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

  def associations do
    [:assessment_type]
  end
end
