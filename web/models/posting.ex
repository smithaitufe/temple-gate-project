defmodule PortalApi.Posting do
  use PortalApi.Web, :model

  schema "postings" do
    field :active, :boolean, default: false
    belongs_to :posted_user, PortalApi.User, foreign_key: :posted_user_id
    belongs_to :department, PortalApi.Department
    belongs_to :salary_grade_step, PortalApi.SalaryGradeStep
    belongs_to :job, PortalApi.Job
    field :effective_date, Ecto.Date
    field :resumption_date, Ecto.Date
    field :posted_date, Ecto.Date

    timestamps
  end

  @required_fields [:posted_user_id, :department_id, :job_id, :salary_grade_step_id, :effective_date, :posted_date]
  @optional_fields [:active, :resumption_date]

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
