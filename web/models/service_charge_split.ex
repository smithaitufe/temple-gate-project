defmodule PortalApi.ServiceChargeSplit do
  use PortalApi.Web, :model

  schema "service_charge_splits" do
    field :amount, :decimal
    field :name, :string
    field :bank_code, :string
    field :account, :string
    field :is_required, :boolean, default: false
    belongs_to :service_charge, PortalApi.ServiceCharge

    timestamps()
  end

  @required_fields [:amount, :name, :bank_code, :account, :service_charge_id]
  @optional_fields [:is_required]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
