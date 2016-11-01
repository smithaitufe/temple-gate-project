defmodule PortalApi.State do
  use PortalApi.Web, :model

  schema "states" do
    field :name, :string
    field :is_catchment_area, :boolean, default: false
    belongs_to :country, PortalApi.Term

    timestamps
  end

  @required_fields [:name, :country_id]
  @optional_fields [:is_catchment_area]

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
end
