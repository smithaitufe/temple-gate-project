defmodule PortalApi.StaffLeaveRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "staff_leave_requests" do
    field :proposed_start_date, Ecto.Date
    field :proposed_end_date, Ecto.Date
    field :read, :boolean, default: false
    field :details, :string
    field :approved, :boolean, default: false
    field :approved_start_date, Ecto.Date
    field :approved_end_date, Ecto.Date
    field :duration, :integer
    field :closed, :boolean, default: false
    field :closed_at, Ecto.DateTime
    field :signed, :boolean, default: false
    field :accepted, :boolean, default: false
    field :deferred, :boolean, default: false

    belongs_to :staff, PortalApi.Staff
    belongs_to :closed_by, PortalApi.Staff, foreign_key: :closed_by_staff_id
    belongs_to :signed_by, PortalApi.Staff, foreign_key: :signed_by_staff_id
    belongs_to :leave_type, PortalApi.Term, foreign_key: :leave_type_id


    timestamps
  end

  @required_fields ~w(staff_id leave_type_id proposed_start_date proposed_end_date)a
  @optional_fields ~w(read details approved approved_start_date approved_end_date duration closed closed_at closed_by_staff_id signed signed_by_staff_id accepted deferred)a

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
    [:closed_by, :signed_by, :leave_type]
  end


end
