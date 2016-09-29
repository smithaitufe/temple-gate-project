defmodule PortalApi.LocalGovernmentArea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "local_government_areas" do
    field :name, :string
    belongs_to :state, PortalApi.State

    timestamps
  end

  @required_fields ~w(name state_id)a
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
