defmodule PortalApi.StudentDiplomaQualification do
  use PortalApi.Web, :model

  schema "student_diploma_qualifications" do
    field :school, :string
    field :course, :string
    field :cgpa, :float
    field :year_admitted, :integer
    field :year_graduated, :integer
    belongs_to :student, PortalApi.Student

    timestamps
  end

  @required_fields ~w(school course cgpa year_admitted year_graduated)
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
end
