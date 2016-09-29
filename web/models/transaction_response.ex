defmodule PortalApi.TransactionResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction_responses" do
    field :code, :string
    field :description, :string

    timestamps
  end

  @required_fields ~w(code description)a
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
