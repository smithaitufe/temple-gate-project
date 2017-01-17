defmodule PortalApi.SalaryGradeStep do
  use PortalApi.Web, :model

  schema "salary_grade_steps" do
    field :description, :string
    belongs_to :salary_grade_level, PortalApi.SalaryGradeLevel

    timestamps
  end


  @required_fields [:description, :salary_grade_level_id]
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
    [:salary_grade_level]
  end
end
