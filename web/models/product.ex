defmodule PortalApi.Product do
  use PortalApi.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :long_description, :string
    field :price, :decimal
    field :quantity, :integer, default: 1
    field :available_at, Ecto.Date
    field :unavailable_at, Ecto.Date
    field :is_negotiable, :boolean, default: false
    belongs_to :sold_by_user, PortalApi.User, foreign_key: :sold_by_user_id
    field :is_sold, :boolean, default: false

    timestamps()
  end

  @required_fields [:sold_by_user_id, :name, :description, :price, :available_at]
  @optional_fields [:long_description, :unavailable_at, :is_negotiable, :quantity, :is_sold]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields )
    |> validate_required(@required_fields)
  end
end
