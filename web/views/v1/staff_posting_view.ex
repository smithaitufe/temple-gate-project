defmodule PortalApi.V1.StaffPostingView do
  use PortalApi.Web, :view

  def render("index.json", %{staff_postings: staff_postings}) do
    render_many(staff_postings, PortalApi.V1.StaffPostingView, "staff_posting.json")
  end

  def render("show.json", %{staff_posting: staff_posting}) do
    render_one(staff_posting, PortalApi.V1.StaffPostingView, "staff_posting.json")
  end

  def render("staff_posting.json", %{staff_posting: staff_posting}) do
    %{id: staff_posting.id,
      staff_id: staff_posting.staff_id,
      department_id: staff_posting.department_id,
      salary_grade_step_id: staff_posting.salary_grade_step_id,
      active: staff_posting.active,
      job_title_id: staff_posting.job_title_id}
  end
end
