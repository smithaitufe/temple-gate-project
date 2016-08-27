defmodule PortalApi.GradeChangeRequest do
  use PortalApi.Web, :model

  schema "grade_change_requests" do
    field :previous_score, :float
    field :previous_grade_letter, :string
    field :current_score, :float
    field :current_grade_letter, :string
    field :read, :boolean, default: false
    field :approved, :boolean, default: false
    field :closed_at, Ecto.DateTime
    field :closed, :boolean, default: false
    belongs_to :student_course_grading, PortalApi.StudentCourseGrading
    belongs_to :reason, PortalApi.Term, foreign_key: :reason_id
    belongs_to :previous_grade, PortalApi.Grade
    belongs_to :current_grade, PortalApi.Grade
    belongs_to :requested_by, PortalApi.Staff, foreign_key: :requested_by_staff_id
    belongs_to :closed_by, PortalApi.Staff, foreign_key: :closed_by_staff_id


    timestamps
  end

  @required_fields ~w(student_course_grading_id requested_by_staff_id previous_score previous_grade_letter previous_grade_id reason_id)
  @optional_fields ~w(current_score current_grade_letter current_grade_id read approved closed closed_at closed_by_staff_id)

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
    [:reason, :requested_by, :closed_by]
  end
end
