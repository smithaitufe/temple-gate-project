defmodule PortalApi.TransactionResponse do
  use PortalApi.Web, :model

  schema "transaction_responses" do
    field :code, :string
    field :description, :string

    timestamps
  end

  @required_fields [:code, :description]
  @optional_fields []

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
