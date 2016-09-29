defmodule PortalApi.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :name, :string
    belongs_to :country, PortalApi.Term

    timestamps
  end

  @required_fields ~w(name country_id)a
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
