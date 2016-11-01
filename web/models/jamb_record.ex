defmodule PortalApi.JambRecord do
  use PortalApi.Web, :model

  schema "jamb_records" do
    field :score, :float
    field :registration_no, :string
    belongs_to :user, PortalApi.User, foreign_key: :user_id

    timestamps
  end

  @required_fields [:user_id, :score, :registration_no]
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
