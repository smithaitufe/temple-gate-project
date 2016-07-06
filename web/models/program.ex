defmodule PortalApi.Program do
  use PortalApi.Web, :model

  schema "programs" do
    field :name, :string
    field :description, :string
    field :text, :string
    field :duration, :integer


    has_many :levels, PortalApi.Level

    timestamps
  end

  @required_fields ~w(name description duration)
  @optional_fields ~w(text)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def load_levels(query) do
    from q in query, join: l in assoc(q, :levels), preload: [levels: l]
  end

  
end
