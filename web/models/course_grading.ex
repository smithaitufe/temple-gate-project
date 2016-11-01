defmodule PortalApi.CourseGrading do
  use PortalApi.Web, :model

  schema "course_gradings" do
    field :score, :float
    field :letter, :string
    field :weight, :float
    field :grade_point, :float
    belongs_to :course_enrollment, PortalApi.CourseEnrollment
    belongs_to :grade, PortalApi.Grade
    belongs_to :uploaded_by, PortalApi.User, foreign_key: :uploaded_by_user_id
    belongs_to :modified_by, PortalApi.User, foreign_key: :modified_by_user_id

    has_many :grade_change_requests, PortalApi.GradeChangeRequest

    timestamps
  end

  @required_fields [:score, :letter, :weight, :grade_point, :grade_id, :course_enrollment_id, :uploaded_by_user_id]
  @optional_fields [:modified_by_user_id]

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
