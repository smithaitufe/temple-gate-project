defmodule PortalApi.V1.PostingView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{PostingView, DepartmentView, JobView, SalaryGradeLevelView, SalaryGradeStepView}

  def render("index.json", %{postings: postings}) do
    render_many(postings, PostingView, "posting.json")
  end

  def render("show.json", %{posting: posting}) do
    render_one(posting, PostingView, "posting.json")
  end

  def render("posting.json", %{posting: posting}) do
    %{
      id: posting.id,
      posted_user_id: posting.posted_user_id,
      department_id: posting.department_id,
      salary_grade_step_id: posting.salary_grade_step_id,
      active: posting.active,
      job_id: posting.job_id,
      posted_date: posting.posted_date,
      resumption_date: posting.resumption_date,
      effective_date: posting.effective_date
    }    
    |> Map.put(:department, render_one(posting.department, DepartmentView, "department_lite.json"))
    |> Map.put(:job, render_one(posting.job, JobView, "job.json"))
    |> Map.put(:salary_grade_level, render_one(posting.salary_grade_step.salary_grade_level, SalaryGradeLevelView, "salary_grade_level.json"))
    |> Map.put(:salary_grade_step, render_one(posting.salary_grade_step, SalaryGradeStepView, "salary_grade_step.json"))
  end


end
