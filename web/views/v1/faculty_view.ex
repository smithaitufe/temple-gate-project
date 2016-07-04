defmodule PortalApi.V1.FacultyView do
  use PortalApi.Web, :view

  def render("index.json", %{faculties: faculties}) do
    %{data: render_many(faculties, PortalApi.V1.FacultyView, "faculty.json")}
  end

  def render("show.json", %{faculty: faculty}) do
    %{data: render_one(faculty, PortalApi.V1.FacultyView, "faculty.json")}
  end

  def render("faculty.json", %{faculty: faculty}) do
    %{id: faculty.id,
      name: faculty.name,
      faculty_type_id: faculty.faculty_type_id}
  end
end
