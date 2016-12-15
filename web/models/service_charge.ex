defmodule PortalApi.ServiceCharge do
  use PortalApi.Web, :model

  schema "service_charges" do
    field :amount, :decimal
    field :active, :boolean, default: false
    belongs_to :program, PortalApi.Program
    belongs_to :payer_category, PortalApi.PayerCategory


    has_many :service_charge_splits, PortalApi.ServiceChargeSplit, foreign_key: :service_charge_id

    timestamps()
  end

  @required_fields [:amount, :program_id, :payer_category_id]
  @optional_fields [:active]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def associations do
    [:service_charge_splits]
  end
end
