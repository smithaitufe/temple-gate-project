defmodule PortalApi.StudentCertificateSubjectGrade do
  use PortalApi.Web, :model

  schema "student_certificate_subject_grades" do
    belongs_to :student_certificate, PortalApi.StudentCertificate
    belongs_to :subject, PortalApi.Term
    belongs_to :grade, PortalApi.Term

    timestamps
  end

  @required_fields ~w()
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
