defmodule PortalApi.StudentCertificate do
  use PortalApi.Web, :model

  schema "student_certificates" do
    field :year_obtained, :integer
    field :registration_no, :string
    belongs_to :student, PortalApi.Student
    belongs_to :examination_body, PortalApi.ExaminationBody

    timestamps
  end

  @required_fields ~w(year_obtained registration_no)
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
