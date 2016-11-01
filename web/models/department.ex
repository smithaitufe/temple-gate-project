defmodule PortalApi.Department do
  use PortalApi.Web, :model

  schema "departments" do
    field :name, :string
    field :code, :string
    belongs_to :faculty, PortalApi.Faculty




    has_many :program_departments, PortalApi.ProgramDepartment
    has_many :courses, PortalApi.Course
    has_many :postings, PortalApi.Posting, foreign_key: :department_id
    has_many :users, through: [:postings, :posted_user]

    timestamps
  end

  @required_fields [:name, :faculty_id]
  @optional_fields [:code]
  
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
