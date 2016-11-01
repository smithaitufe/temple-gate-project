defmodule PortalApi.AcademicQualification do
  use PortalApi.Web, :model

  schema "academic_qualifications" do
    field :school, :string
    field :course_studied, :string
    field :from, :integer
    field :to, :integer
    belongs_to :user, PortalApi.User, foreign_key: :user_id
    belongs_to :certificate_type, PortalApi.Term, foreign_key: :certificate_type_id

    timestamps
  end

  @required_fields [:user_id, :certificate_type_id, :school, :course_studied, :from, :to]
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
