defmodule PortalApi.StaffLeaveEntitlement do
  use PortalApi.Web, :model

  schema "staff_leave_entitlements" do
    field :entitled_leave, :integer
    field :remaining_leave, :integer
    belongs_to :staff, PortalApi.Staff
    belongs_to :leave_track_type, PortalApi.Term, foreign_key: :leave_track_type_id

    timestamps
  end

  @required_fields ~w(staff_id leave_track_type_id entitled_leave)
  @optional_fields ~w(remaining_leave)

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
