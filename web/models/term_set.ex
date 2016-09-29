defmodule PortalApi.TermSet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "term_sets" do
    field :name, :string
    field :display_name, :string

    timestamps
  end

  @required_fields ~w(name display_name)a
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
