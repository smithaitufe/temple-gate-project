defmodule PortalApi.StaffPosting do
  use PortalApi.Web, :model

  schema "staff_postings" do
    field :active, :boolean, default: false
    belongs_to :staff, PortalApi.Staff
    belongs_to :department, PortalApi.Department
    belongs_to :salary_grade_step, PortalApi.SalaryGradeStep
    belongs_to :job, PortalApi.Job

    timestamps
  end

  @required_fields ~w(staff_id department_id salary_grade_step_id job_id)
  @optional_fields ~w(active)

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
