defmodule PortalApi.V1.ProgramDepartmentView do
  use PortalApi.Web, :view

  def render("index.json", %{program_departments: program_departments}) do
    %{data: render_many(program_departments, PortalApi.V1.ProgramDepartmentView, "program_department.json")}
  end

  def render("show.json", %{program_department: program_department}) do
    %{data: render_one(program_department, PortalApi.V1.ProgramDepartmentView, "program_department.json")}
  end

  def render("program_department.json", %{program_department: program_department}) do
    %{id: program_department.id,
      program_id: program_department.program_id,
      department_id: program_department.department_id}
  end
end
