defmodule PortalApi.CourseEnrollment do
  use PortalApi.Web, :model

  schema "course_enrollments" do
    belongs_to :course, PortalApi.Course, foreign_key: :course_id
    belongs_to :level, PortalApi.Level, foreign_key: :level_id
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :academic_session, PortalApi.AcademicSession, foreign_key: :academic_session_id
    field :graded, :boolean, default: false
    
    has_one :course_grading, PortalApi.CourseGrading
    has_many :assessments, PortalApi.CourseEnrollmentAssessment
    has_many :course_enrollments, PortalApi.CourseEnrollment


    timestamps
  end

  @required_fields [:user_id, :course_id, :level_id, :academic_session_id]
  @optional_fields [:graded]

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


  def associations do
    course_query = from c in PortalApi.Course, preload: [:department, :semester, :level]
     [
       :user, :academic_session, {:course, [{:department, [:faculty]}, :level, :semester]},
      :course_grading, {:assessments, [:assessment_type]}
    ]
  end
end
