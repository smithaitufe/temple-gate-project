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
    belongs_to :course_grading, PortalApi.CourseGrading
    belongs_to :reason, PortalApi.Term, foreign_key: :reason_id
    belongs_to :previous_grade, PortalApi.Grade, foreign_key: :previous_grade_id
    belongs_to :current_grade, PortalApi.Grade, foreign_key: :current_grade_id
    belongs_to :requester, PortalApi.User, foreign_key: :requester_user_id
    belongs_to :closed_by, PortalApi.User, foreign_key: :closed_by_user_id


    timestamps
  end

  @required_fields [:course_grading_id, :requester_user_id, :previous_score, :previous_grade_letter, :previous_grade_id, :reason_id]
  @optional_fields [:current_score, :current_grade_letter, :current_grade_id, :read, :approved, :closed, :closed_at, :closed_by_user_id]

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
    [:reason, :requester, :closed_by]
  end
end
