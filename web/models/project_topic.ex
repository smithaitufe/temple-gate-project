defmodule PortalApi.ProjectTopic do
  use Ecto.Schema

  schema "project_topics" do
    field :title, :string
    field :approved, :boolean, default: false
    belongs_to :student, PortalApi.Student

    timestamps
  end

  @required_fields ~w(title approved)a
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
