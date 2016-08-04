defmodule PortalApi.Fee do
  use PortalApi.Web, :model

  schema "fees" do
    field :code, :string
    field :description, :string
    field :amount, :decimal
    field :service_charge, :decimal
    field :is_catchment_area, :boolean, default: false
    belongs_to :program, PortalApi.Program
    belongs_to :level, PortalApi.Level
    belongs_to :fee_category, PortalApi.Term

    timestamps
  end

  @required_fields ~w(program_id fee_category_id code description amount service_charge is_catchment_area)
  @optional_fields ~w(level_id)

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
