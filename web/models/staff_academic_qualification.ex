defmodule PortalApi.StaffAcademicQualification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "staff_academic_qualifications" do
    field :school, :string
    field :course_studied, :string
    field :from, :integer
    field :to, :integer
    belongs_to :staff, PortalApi.Staff
    belongs_to :certificate, PortalApi.Certificate

    timestamps
  end

  @required_fields ~w(school course_studied from to)a
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
