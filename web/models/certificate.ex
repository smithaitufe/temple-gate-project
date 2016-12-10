defmodule PortalApi.Certificate do
  use PortalApi.Web, :model

  schema "certificates" do
    field :year_obtained, :integer
    field :registration_no, :string
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :examination_type, PortalApi.Term, foreign_key: :examination_type_id

    has_many :certificate_items, PortalApi.CertificateItem

    timestamps
  end

  @required_fields [:user_id, :year_obtained, :examination_type_id, :registration_no]
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
