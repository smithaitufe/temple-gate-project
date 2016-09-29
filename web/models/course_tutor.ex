defmodule PortalApi.CourseTutor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "course_tutors" do
    field :grades_submitted, :boolean, default: false
    field :grades_submitted_at, Ecto.DateTime
    belongs_to :course, PortalApi.Course
    belongs_to :staff, PortalApi.Staff
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(course_id staff_id academic_session_id)a
  @optional_fields ~w(grades_submitted grades_submitted_at)a

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

  def preload_associations(query) do
    from q in query,
    preload: [:course, :staff]
  end
end
