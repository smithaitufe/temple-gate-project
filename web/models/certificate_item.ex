defmodule PortalApi.CertificateItem do
  use PortalApi.Web, :model

  schema "student_certificate_items" do
    belongs_to :certificate, PortalApi.Certificate
    belongs_to :subject, PortalApi.Term, foreign_key: :subject_id
    belongs_to :grade, PortalApi.Term, foreign_key: :grade_id

    timestamps
  end

  @required_fields [:certificate_id, :subject_id, :grade_id]
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
