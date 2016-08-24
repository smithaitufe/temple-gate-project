defmodule PortalApi.CourseTutor do
  use PortalApi.Web, :model

  schema "course_tutors" do
    belongs_to :course, PortalApi.Course
    belongs_to :staff, PortalApi.Staff
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(course_id staff_id academic_session_id)
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

  def preload_associations(query) do
    from q in query,
    preload: [:course, :staff]
  end
end
