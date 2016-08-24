defmodule PortalApi.StudentCourseGrading do
  use PortalApi.Web, :model

  schema "student_course_gradings" do
    field :exam, :float
    field :ca, :float
    field :total, :float
    field :letter, :string
    field :weight, :float
    field :grade_point, :float
    belongs_to :student_course, PortalApi.StudentCourse
    belongs_to :grade, PortalApi.Grade
    belongs_to :uploaded_by, PortalApi.Staff, foreign_key: :uploaded_by_staff_id
    belongs_to :edited_by, PortalApi.Staff, foreign_key: :edited_by_staff_id

    timestamps
  end

  @required_fields ~w(exam ca total letter weight grade_point grade_id student_course_id uploaded_by_staff_id)
  @optional_fields ~w(edited_by_staff_id)

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
