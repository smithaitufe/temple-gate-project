defmodule PortalApi.StudentDiplomaQualification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_diploma_qualifications" do
    field :school, :string
    field :course, :string
    field :cgpa, :float
    field :year_admitted, :integer
    field :year_graduated, :integer
    belongs_to :student, PortalApi.Student

    timestamps
  end

  @required_fields ~w(school course cgpa year_admitted year_graduated)a
  @optional_fields ~w()a

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
