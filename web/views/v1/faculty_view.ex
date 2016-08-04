defmodule PortalApi.V1.FacultyView do
  use PortalApi.Web, :view
  alias PortalApi.V1.FacultyView


  def render("index.json", %{faculties: faculties}) do
    render_many(faculties, FacultyView, "faculty.json")
  end

  def render("show.json", %{faculty: faculty}) do
    render_one(faculty, FacultyView, "faculty.json")
  end

  def render("faculty.json", %{faculty: faculty}) do
    %{
      id: faculty.id,
      name: faculty.name,
      faculty_type_id: faculty.faculty_type_id
    }
  end

  def render_faculty(json, %{faculty: faculty}) when is_map(faculty) do
    Map.put(json, :faculty, render("faculty.json", faculty: faculty))
  end

  def render_faculty(json, _), do: Map.put(json, :faculty, %{})
end
