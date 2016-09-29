defmodule PortalApi.StudentCertificate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_certificates" do
    field :year_obtained, :integer
    field :registration_no, :string
    belongs_to :student, PortalApi.Student
    belongs_to :examination_body, PortalApi.ExaminationBody

    has_many :student_certificate_items, PortalApi.StudentCertificateSubjectGrade

    timestamps
  end

  @required_fields ~w(year_obtained examination_body_id registration_no)a
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
