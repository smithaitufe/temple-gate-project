defmodule PortalApi.StudentProjectSupervisor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_project_supervisors" do
    belongs_to :staff, PortalApi.Staff
    belongs_to :student, PortalApi.Student
    belongs_to :project_status, PortalApi.ProjectStatus

    timestamps
  end

  @required_fields ~w(staff_id student_id project_status_id)a
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
