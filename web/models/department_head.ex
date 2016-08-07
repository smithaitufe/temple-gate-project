defmodule PortalApi.DepartmentHead do
  use PortalApi.Web, :model

  schema "department_heads" do
    field :active, :boolean, default: false
    field :appointment_date, Ecto.Date
    field :effective_date, Ecto.Date
    field :end_date, :string
    belongs_to :department, PortalApi.Department
    belongs_to :staff, PortalApi.Staff

    timestamps
  end

  @required_fields ~w(staff_id department_id appointment_date effective_date end_date)
  @optional_fields ~w(active)

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
