defmodule PortalApi.DepartmentHead do
  use PortalApi.Web, :model


  schema "department_heads" do
    field :active, :boolean, default: false
    field :appointment_date, Ecto.Date
    field :effective_date, Ecto.Date
    field :end_date, :string
    belongs_to :department, PortalApi.Department
    belongs_to :user, PortalApi.User, foreign_key: :assigned_user_id

    timestamps
  end

  @required_fields [:assigned_user_id, :department_id, :appointment_date, :effective_date, :end_date]
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
    [:department, :user]
  end
end
