defmodule PortalApi.UserRole do
  use PortalApi.Web, :model

  schema "user_roles" do
    field :default, :boolean, default: false
    belongs_to :user, PortalApi.User
    belongs_to :role, PortalApi.Term

    timestamps
  end

  @required_fields ~w(user_id role_id default)
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
