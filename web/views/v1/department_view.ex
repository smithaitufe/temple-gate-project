defmodule PortalApi.V1.DepartmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{DepartmentView, FacultyView, TermView}

  def render("index.json", %{departments: departments}) do
    render_many(departments, DepartmentView, "department.json")
  end

  def render("show.json", %{department: department}) do
    render_one(department, DepartmentView, "department.json")
  end

  def render("department.json", %{department: department}) do
    render("department_lite.json", department: department)
    |> FacultyView.render_faculty(%{faculty: department.faculty})
    |> TermView.render_term("department_type", %{term: department.department_type})
  end
  def render("department_lite.json", %{department: department}) do
    %{
      id: department.id,
      name: department.name,
      faculty_id: department.faculty_id,
      department_type_id: department.department_type_id,
      code: department.code
    }
  end

  def render_department(json, %{department: department}) when is_map(department) do
    Map.put(json, :department, render_one(department, DepartmentView, "department.json"))
  end
  def render_department(json, _) do
    json
  end
end
