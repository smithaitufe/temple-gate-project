defmodule PortalApi.Newsroom do
  use PortalApi.Web, :model

  schema "newsrooms" do
    field :heading, :string
    field :lead, :string
    field :body, :string
    field :release_at, Ecto.Date
    field :active, :boolean, default: true
    field :duration, :integer

    timestamps
  end

  @required_fields ~w(heading lead body release_at active duration)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
