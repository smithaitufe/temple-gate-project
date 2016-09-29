defmodule PortalApi.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :title, :string
    field :description, :string
    field :qualifications, :string
    field :responsibilities, :string
    belongs_to :department_type, PortalApi.Term
    field :open, :boolean, default: false

    timestamps
  end

  @required_fields ~w(title description department_type_id)a
  @optional_fields ~w(qualifications responsibilities open)a

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
