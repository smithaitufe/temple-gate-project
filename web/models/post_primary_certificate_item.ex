defmodule PortalApi.PostPrimaryCertificateItem do
  use PortalApi.Web, :model

  schema "post_primary_certificate_items" do
    belongs_to :post_primary_certificate, PortalApi.PostPrimaryCertificate
    belongs_to :subject, PortalApi.Term, foreign_key: :subject_id
    belongs_to :grade, PortalApi.Term, foreign_key: :grade_id

    timestamps
  end

  @required_fields [:post_primary_certificate_id, :subject_id, :grade_id]
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

  def associations do
    [:subject, :grade]
  end
end
