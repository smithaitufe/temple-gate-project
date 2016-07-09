defmodule PortalApi.Course do
  use PortalApi.Web, :model

  schema "courses" do
    field :code, :string
    field :title, :string
    field :units, :integer
    field :hours, :integer
    field :core, :boolean, default: false
    field :description, :string
    belongs_to :department, PortalApi.Department
    belongs_to :level, PortalApi.Level
    belongs_to :semester, PortalApi.Term

    timestamps

    has_many :enrollments, PortalApi.CourseEnrollment
  end

  @required_fields ~w(code title units hours core department_id level_id semester_id)
  @optional_fields ~w(description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def load_associations(query \\ %PortalApi.Course{}) do
    query = from q in query,
            join: s in assoc(q, :semester),
            join: l in assoc(q, :level),
            join: d in assoc(q, :department),
            preload: [semester: s, level: l, department: d]

    query

  end
end
