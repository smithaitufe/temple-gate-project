defmodule PortalApi.Fee do
  use PortalApi.Web, :model
  alias PortalApi.{Program, Level, Term}

  schema "fees" do
    field :code, :string
    field :description, :string
    field :amount, :decimal
    belongs_to :program, Program
    belongs_to :level, Level
    belongs_to :fee_category, Term, foreign_key: :fee_category_id
    belongs_to :payer_category, Term, foreign_key: :payer_category_id
    belongs_to :service_charge, Term, foreign_key: :service_charge_id
    field :is_catchment, :boolean
    field :is_all, :boolean
    

    timestamps
  end

  @required_fields [:program_id, :level_id, :payer_category_id, :fee_category_id, :code, :description, :amount]
  @optional_fields [:is_catchment, :is_all]

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
    [{:program, [levels: level_query]}, :level, :fee_category, :payer_category]
  end


end
