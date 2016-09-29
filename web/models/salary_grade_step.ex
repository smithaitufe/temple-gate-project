defmodule PortalApi.SalaryGradeStep do
  use Ecto.Schema
  import Ecto.Changeset

  schema "salary_grade_steps" do
    field :description, :string
    belongs_to :salary_grade_level, PortalApi.SalaryGradeLevel

    timestamps
  end

  @required_fields ~w(description salary_grade_level_id)a
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
