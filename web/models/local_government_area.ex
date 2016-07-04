defmodule PortalApi.LocalGovernmentArea do
  use PortalApi.Web, :model

  schema "local_government_areas" do
    field :name, :string
    belongs_to :state, PortalApi.State

    timestamps
  end

  @required_fields ~w(name state_id)
  @optional_fields ~w()

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
