defmodule PortalApi.Grade do
  use PortalApi.Web, :model

  schema "grades" do
    field :maximum, :integer
    field :minimum, :integer
    field :point, :float
    field :description, :string

    timestamps
  end

  @required_fields ~w(maximum minimum point description)a
  @optional_fields ~w()a

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
