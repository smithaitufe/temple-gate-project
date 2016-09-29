defmodule PortalApi.StudentCourseGrading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_course_gradings" do
    field :score, :float
    field :letter, :string
    field :weight, :float
    field :grade_point, :float
    belongs_to :student_course, PortalApi.StudentCourse
    belongs_to :grade, PortalApi.Grade
    belongs_to :uploaded_by, PortalApi.Staff, foreign_key: :uploaded_by_staff_id
    belongs_to :edited_by, PortalApi.Staff, foreign_key: :edited_by_staff_id

    has_many :grade_change_requests, PortalApi.GradeChangeRequest

    timestamps
  end

  @required_fields ~w(score letter weight grade_point grade_id student_course_id uploaded_by_staff_id)a
  @optional_fields ~w(edited_by_staff_id)a

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
