defmodule PortalApi.V1.StaffPostingView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{StaffPostingView, StaffView, DepartmentView, JobView}

  def render("index.json", %{staff_postings: staff_postings}) do
    render_many(staff_postings, StaffPostingView, "staff_posting.json")
  end

  def render("show.json", %{staff_posting: staff_posting}) do
    render_one(staff_posting, StaffPostingView, "staff_posting.json")
  end

  def render("staff_posting.json", %{staff_posting: staff_posting}) do
    %{id: staff_posting.id,
      staff_id: staff_posting.staff_id,
      department_id: staff_posting.department_id,
      salary_grade_step_id: staff_posting.salary_grade_step_id,
      active: staff_posting.active,
      job_id: staff_posting.job_id,
      posted_date: staff_posting.posted_date,
      resumption_date: staff_posting.resumption_date,
      effective_date: staff_posting.effective_date
    }
    |> Map.put(:staff, render_one(staff_posting.staff, StaffView, "staff.json"))
    |> Map.put(:department, render_one(staff_posting.department, DepartmentView, "department_lite.json"))
    |> Map.put(:job, render_one(staff_posting.job, JobView, "job.json"))
  end
end
