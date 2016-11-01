defmodule PortalApi.DiplomaQualification do
  use PortalApi.Web, :model

  schema "diploma_qualifications" do
    field :school, :string
    field :course, :string
    field :cgpa, :float
    field :year_admitted, :integer
    field :year_graduated, :integer
    belongs_to :user, PortalApi.User, foreign_key: :user_id

    timestamps
  end

  @required_fields [:user_id, :school, :course, :cgpa, :year_admitted, :year_graduated]
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
