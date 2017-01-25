defmodule PortalApi.PostSecondaryCertificate do
  use PortalApi.Web, :model

  schema "post_secondary_certificates" do
    field :school, :string
    field :course_studied, :string
    field :cgpa, :float
    field :year_admitted, :integer
    field :year_graduated, :integer
    field :verified, :boolean, default: false
    field :verified_at, Ecto.DateTime
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :verified_by, PortalApi.User, foreign_key: :verified_by_user_id

    timestamps
  end

  @required_fields [:user_id, :school, :course_studied, :cgpa, :year_admitted, :year_graduated]
  @optional_fields [:verified, :verified_at, :verified_by_user_id]

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
