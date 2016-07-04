defmodule PortalApi.AcademicSession do
  use PortalApi.Web, :model

  schema "academic_sessions" do
    field :description, :string
    field :opening_date, Ecto.DateTime
    field :closing_date, Ecto.DateTime
    field :is_current, :boolean, default: false

    timestamps
  end

  @required_fields ~w(description opening_date closing_date is_current)
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
