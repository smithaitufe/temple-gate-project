defmodule PortalApi.StaffLeaveRequest do
  use PortalApi.Web, :model

  schema "staff_leave_requests" do
    field :proposed_start_date, Ecto.Date
    field :proposed_end_date, Ecto.Date
    field :read, :boolean, default: false
    field :details, :string
    field :approved, :boolean, default: false
    field :approved_start_date, Ecto.Date
    field :approved_end_date, Ecto.Date
    field :no_of_days, :integer
    field :closed, :boolean, default: false
    field :closed_at, Ecto.DateTime
    belongs_to :staff, PortalApi.Staff
    belongs_to :closed_by, PortalApi.Staff, foreign_key: :closed_by_staff_id
    belongs_to :leave_type, PortalApi.Term, foreign_key: :leave_type_id


    timestamps
  end

  @required_fields ~w(staff_id leave_type_id proposed_start_date proposed_end_date)
  @optional_fields ~w(read details approved approved_start_date approved_end_date no_of_days closed closed_at closed_by_staff_id)

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
