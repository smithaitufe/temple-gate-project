defmodule PortalApi.Fee do
  use PortalApi.Web, :model
  alias PortalApi.{Program, Level, Term}

  schema "fees" do
    field :code, :string
    field :description, :string
    field :amount, :decimal
    field :service_charge, :decimal
    belongs_to :program, Program
    belongs_to :level, Level
    belongs_to :fee_category, Term
    belongs_to :payer_category, Term
    belongs_to :area_type, Term

    timestamps
  end

  @required_fields [:program_id, :level_id, :area_type_id, :payer_category_id, :fee_category_id, :code, :description, :amount, :service_charge]
  @optional_fields []

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
    level_query = from l in PortalApi.Level, order_by: [asc: l.id]
    [{:program, [levels: level_query]}, :level, :fee_category, :payer_category, :area_type]
  end


end
