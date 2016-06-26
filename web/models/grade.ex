defmodule PortalApi.Grade do
  use PortalApi.Web, :model

  schema "grades" do
    field :maximum, :integer
    field :minimum, :integer
    field :point, :float

    timestamps
  end

  @required_fields ~w(maximum minimum point)
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
