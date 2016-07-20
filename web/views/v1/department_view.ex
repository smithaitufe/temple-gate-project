defmodule PortalApi.V1.DepartmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.DepartmentView

  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{id: department.id,
      name: department.name,
      faculty_id: department.faculty_id,
      department_type_id: department.department_type_id,
      code: department.code      
    }
    |> PortalApi.V1.FacultyView.render_faculty(%{faculty: department.faculty})
    |> PortalApi.V1.TermView.render_term("department_type", %{term: department.department_type})
  end

  def render_department(json, %{department: department}) when is_map(department) do
    Map.put(json, :department, render_one(department, DepartmentView, "department.json"))
  end
  def render_department(json, _) do
    json
  end
end
