defmodule PortalApi.Department do
  use Ecto.Schema
  import Ecto.Changeset

  schema "departments" do
    field :name, :string
    field :code, :string
    belongs_to :faculty, PortalApi.Faculty




    has_many :program_departments, PortalApi.ProgramDepartment
    has_many :courses, PortalApi.Course
    has_many :staff_postings, PortalApi.StaffPosting, foreign_key: :department_id
    has_many :staffs, through: [:staff_postings, :staff]

    timestamps
  end

  @required_fields ~w(name faculty_id)
  @optional_fields ~w(code)

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
