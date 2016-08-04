defmodule PortalApi.V1.FacultyHeadView do
  use PortalApi.Web, :view

  def render("index.json", %{faculty_heads: faculty_heads}) do
    %{data: render_many(faculty_heads, PortalApi.V1.FacultyHeadView, "faculty_head.json")}
  end

  def render("show.json", %{faculty_head: faculty_head}) do
    %{data: render_one(faculty_head, PortalApi.V1.FacultyHeadView, "faculty_head.json")}
  end

  def render("faculty_head.json", %{faculty_head: faculty_head}) do
    %{id: faculty_head.id,
      faculty_id: faculty_head.faculty_id,
      staff_id: faculty_head.staff_id,
      active: faculty_head.active,
      appointment_date: faculty_head.appointment_date,
      effective_date: faculty_head.effective_date,
      end_date: faculty_head.end_date}
  end
end
