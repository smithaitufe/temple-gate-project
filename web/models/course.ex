defmodule PortalApi.Course do
  use PortalApi.Web, :model


  schema "courses" do
    field :code, :string
    field :title, :string
    field :units, :integer
    field :hours, :integer
    field :description, :string
    belongs_to :department, PortalApi.Department
    belongs_to :level, PortalApi.Level
    belongs_to :semester, PortalApi.Term, foreign_key: :semester_id
    belongs_to :course_category, PortalApi.Term, foreign_key: :course_category_id

    timestamps

    has_many :course_enrollments, PortalApi.CourseEnrollment, foreign_key: :course_id


  end

  @required_fields [:code, :title, :units, :hours, :department_id, :level_id, :semester_id, :course_category_id]
  @optional_fields [:description]

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

  def load_associations(query \\ %PortalApi.Course{}) do
    query = from q in query,
            join: s in assoc(q, :semester),
            join: l in assoc(q, :level),
            join: d in assoc(q, :department),
            preload: [semester: s, level: l, department: d]

    query

  end

  def associations() do
    [:semester, :level, {:department, [:faculty]}, :course_category]
  end
end
