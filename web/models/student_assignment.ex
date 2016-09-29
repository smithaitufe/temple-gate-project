defmodule PortalApi.StudentAssignment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_assignments" do
    field :submission, :string
    belongs_to :student, PortalApi.Student
    belongs_to :assignment, PortalApi.Assignment

    timestamps
  end

  @required_fields ~w(student_id assignment_id submission)a
  @optional_fields ~w()

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
