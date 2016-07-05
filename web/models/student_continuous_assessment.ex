defmodule PortalApi.StudentContinuousAssessment do
  use PortalApi.Web, :model

  schema "student_continuous_assessments" do
    field :score, :float
    belongs_to :course, PortalApi.Course
    belongs_to :staff, PortalApi.Staff
    belongs_to :student, PortalApi.Student
    belongs_to :continuous_assessment_type, PortalApi.Term

    timestamps
  end

  @required_fields ~w(score staff_id course_id student_id continuous_assessment_type_id)
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