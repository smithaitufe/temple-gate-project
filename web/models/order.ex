defmodule PortalApi.Order do
  use PortalApi.Web, :model

  schema "orders" do
    field :selling_amount, :decimal
    field :buying_amount, :decimal
    field :is_invited, :boolean, default: false
    field :buyer, :boolean, default: false
    belongs_to :ordered_by_user, PortalApi.OrderedByUser
    belongs_to :product, PortalApi.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:selling_amount, :buying_amount, :is_invited, :buyer])
    |> validate_required([:selling_amount, :buying_amount, :is_invited, :buyer])
  end
end
