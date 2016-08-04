defmodule PortalApi.SalaryGradeLevel do
  use PortalApi.Web, :model

  schema "salary_grade_levels" do
    field :description, :string
    belongs_to :salary_structure_type, PortalApi.Term

    has_many :salary_grade_steps, PortalApi.V1.SalaryGradeStep
    timestamps
  end

  @required_fields ~w(description salary_structure_type_id)
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
