defmodule PortalApi.Announcement do
  use PortalApi.Web, :model

  schema "announcements" do
    field :heading, :string
    field :lead, :string
    field :body, :string    
    field :expires_at, Ecto.Date
    field :active, :boolean, default: true    
    field :show_as_dialog, :boolean, default: false

    timestamps
  end

  @required_fields [:heading, :lead, :body, :expires_at, :active]
  @optional_fields [:show_as_dialog]

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
