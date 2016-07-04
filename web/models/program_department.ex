defmodule PortalApi.ProgramDepartment do
  use PortalApi.Web, :model

  schema "program_departments" do
    belongs_to :program, PortalApi.Program
    belongs_to :department, PortalApi.Department

    timestamps
  end

  @required_fields ~w()
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
