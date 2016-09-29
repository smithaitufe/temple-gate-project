defmodule PortalApi.StudentCourse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_courses" do
    belongs_to :course, PortalApi.Course
    belongs_to :level, PortalApi.Course
    belongs_to :student, PortalApi.Student
    belongs_to :academic_session, PortalApi.AcademicSession
    field :graded, :boolean, default: false
    has_one :course_grading, PortalApi.StudentCourseGrading
    has_many :assessments, PortalApi.StudentCourseAssessment


    timestamps
  end

  @required_fields ~w(student_id course_id level_id academic_session_id)a
  @optional_fields ~w(graded)a

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


  def load_associations(query) do
    course_query = from c in PortalApi.Course, preload: [:department, :semester, :level]
    from q in query,
    join: c in assoc(q, :course),
    join: s in assoc(q, :student),
    join: a in assoc(q, :academic_session),
    preload: [course: ^course_query, student: s, academic_session: a]
  end

  def associations do
     [
       {:student,[:gender, :marital_status, {:program, [:levels]}, :level, {:department, [:faculty]}] },
        :academic_session,
      {:course, [{:department, [:faculty]}, :level, :semester, :course_category]},
      :course_grading, {:assessments, [:assessment_type]}
    ]
  end


  def filter_by(query, {"student", value}) do
    from [q, c, s, a] in query,
    where: q.student_id == ^value
  end
  def filter_by(query, {"level", value}) do
    from [q, c, s, a] in query,
    where: c.level_id == ^value
  end

end
