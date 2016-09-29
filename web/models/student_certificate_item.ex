defmodule PortalApi.StudentCertificateItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_certificate_items" do
    belongs_to :student_certificate, PortalApi.StudentCertificate
    belongs_to :subject, PortalApi.Term
    belongs_to :grade, PortalApi.Term

    timestamps
  end

  @required_fields ~w(student_certificate_id subject_id grade_id)a
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
