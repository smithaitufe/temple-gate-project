defmodule PortalApi.Newsroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "newsrooms" do
    field :heading, :string
    field :lead, :string
    field :body, :string
    field :release_at, Ecto.Date
    field :active, :boolean, default: true
    field :duration, :integer

    timestamps
  end

  @required_fields ~w(heading lead body release_at active duration)a
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
