defmodule PortalApi.CourseTutor do
  use PortalApi.Web, :model

  schema "course_tutors" do
    field :grades_submitted, :boolean, default: false
    field :grades_submitted_at, Ecto.DateTime
    belongs_to :course, PortalApi.Course, foreign_key: :course_id
    belongs_to :tutor, PortalApi.User, foreign_key: :tutor_user_id
    belongs_to :assigned_by, PortalApi.User, foreign_key: :assigned_by_user_id
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields [:course_id, :tutor_user_id, :assigned_by_user_id, :academic_session_id]
  @optional_fields [:grades_submitted, :grades_submitted_at]

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

  def associations() do
    [:course, :tutor, :assigned_by, :academic_session]
  end
end
