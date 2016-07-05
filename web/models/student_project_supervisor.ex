defmodule PortalApi.StudentProjectSupervisor do
  use PortalApi.Web, :model

  schema "student_project_supervisors" do
    belongs_to :staff, PortalApi.Staff
    belongs_to :student, PortalApi.Student
    belongs_to :project_status, PortalApi.ProjectStatus

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
