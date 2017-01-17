defmodule PortalApi.Posting do
  use PortalApi.Web, :model

  alias PortalApi.{Department, SalaryGradeStep, User, Job}

  schema "postings" do
    field :active, :boolean, default: false
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :department, Department
    belongs_to :salary_grade_step, SalaryGradeStep
    belongs_to :job, Job
    field :effective_date, Ecto.Date
    field :resumption_date, Ecto.Date
    field :posted_date, Ecto.Date

    timestamps
  end

  @required_fields [:user_id, :department_id, :job_id, :salary_grade_step_id, :effective_date, :posted_date]
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

  def associations do
    [:user, {:department, Department.associations}, :job, {:salary_grade_step, SalaryGradeStep.associations} ]
  end
end
