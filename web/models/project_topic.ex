defmodule PortalApi.ProjectTopic do
  use PortalApi.Web, :model

  schema "project_topics" do
    field :title, :string
    field :approved, :boolean, default: false
    belongs_to :submitted_by, PortalApi.User, foreign_key: :submitted_by_user_id

    timestamps
  end

  @required_fields [:submitted_by_user_id, :title, :approved]
  @optional_fields []

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
