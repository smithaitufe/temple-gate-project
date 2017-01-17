defmodule PortalApi.DepartmentHead do
  use PortalApi.Web, :model
  alias PortalApi.{Department, User}


  schema "department_heads" do
    field :active, :boolean, default: false
    field :appointment_date, Ecto.Date
    field :effective_date, Ecto.Date
    field :termination_date, :string
    belongs_to :department, PortalApi.Department
    belongs_to :user, PortalApi.User, foreign_key: :user_id

    timestamps
  end

  @required_fields [:user_id, :department_id, :appointment_date, :effective_date, :termination_date]
  @optional_fields [:active]

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
    [department: Department.associations, user: User.staff_associations]
  end
end
