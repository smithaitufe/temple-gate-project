defmodule PortalApi.StaffPosting do
  use PortalApi.Web, :model

  schema "staff_postings" do
    field :active, :boolean, default: false
    belongs_to :staff, PortalApi.Staff
    belongs_to :department, PortalApi.Department
    belongs_to :salary_grade_step, PortalApi.SalaryGradeStep
    belongs_to :job_title, PortalApi.JobTitle

    timestamps
  end

  @required_fields ~w(active)
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
