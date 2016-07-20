defmodule PortalApi.StudentCourse do
  use PortalApi.Web, :model

  schema "student_courses" do
    belongs_to :course, PortalApi.Course
    belongs_to :student, PortalApi.Student
    belongs_to :academic_session, PortalApi.AcademicSession


    timestamps
  end

  @required_fields ~w(student_id course_id academic_session_id)
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


  def load_associations(query) do
    course_query = from c in PortalApi.Course, preload: [:department, :semester, :level]

    from q in query,
    join: c in assoc(q, :course),
    join: s in assoc(q, :student),
    join: a in assoc(q, :academic_session),
    preload: [course: ^course_query, student: s, academic_session: a]


    
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
