defmodule PortalApi.AcademicSession do
  use Ecto.Schema
  import Ecto.Changeset
  use Timex

  schema "academic_sessions" do
    field :description, :string
    field :opening_date, Timex.Ecto.Date
    field :closing_date, Timex.Ecto.Date
    field :active, :boolean, default: true

    timestamps
  end

  @required_fields ~w(description opening_date closing_date active)a
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
