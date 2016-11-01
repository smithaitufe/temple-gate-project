defmodule PortalApi.Term do
  use PortalApi.Web, :model

  schema "terms" do
    field :description, :string
    belongs_to :term_set, PortalApi.TermSet

    timestamps
  end

  @required_fields ~w(description term_set_id)a
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
