defmodule PortalApi.Department do
  use PortalApi.Web, :model

  schema "departments" do
    field :name, :string
    field :code, :string
    belongs_to :faculty, PortalApi.Faculty
    belongs_to :department_type, PortalApi.DepartmentType

    timestamps
  end

  @required_fields ~w(name code)
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
