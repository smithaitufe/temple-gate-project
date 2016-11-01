defmodule PortalApi.CourseEnrollmentAssessment do
  use PortalApi.Web, :model

  schema "course_enrollment_assessments" do
    field :score, :float
    field :active, :boolean, default: true
    belongs_to :course_enrollment, PortalApi.CourseEnrollment, foreign_key: :course_enrollment_id
    belongs_to :assessed_by, PortalApi.User, foreign_key: :assessed_by_user_id
    belongs_to :assessment_type, PortalApi.Term, foreign_key: :assessment_type_id
    

    timestamps
  end

  @required_fields [:assessed_by_user_id, :course_enrollment_id, :assessment_type_id, :score]
  @optional_fields []

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
    [:assessment_type]
  end
end
