defmodule PortalApi.ProgramDepartment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "program_departments" do
    belongs_to :program, PortalApi.Program
    belongs_to :department, PortalApi.Department
    field :admit, :boolean, default: false
    timestamps
  end

  @required_fields ~w(program_id department_id)a
  @optional_fields ~w(admit)a

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

  def program_department_advert_changeset(model, params \\ :empty) do

  end
end
