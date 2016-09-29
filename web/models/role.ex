defmodule PortalApi.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string
    field :slug, :string
    timestamps
  end

  @required_fields ~w(name description)a
  @optional_fields ~w(slug)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> generate_slug
  end

  defp generate_slug(changeset) do
    if description = get_change(changeset, :description) do
      slug = description
      |> String.downcase
      |> String.replace(~r/[^\w-]+/, "-")
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end
end
