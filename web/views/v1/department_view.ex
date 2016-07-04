defmodule PortalApi.V1.DepartmentView do
  use PortalApi.Web, :view

  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, PortalApi.V1.DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, PortalApi.V1.DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{id: department.id,
      name: department.name,
      faculty_id: department.faculty_id,
      department_type_id: department.department_type_id,
      code: department.code}
  end
end
