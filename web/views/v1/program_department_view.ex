defmodule PortalApi.V1.ProgramDepartmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{ProgramDepartmentView, ProgramView, DepartmentView}

  def render("index.json", %{program_departments: program_departments}) do
    %{data: render_many(program_departments, ProgramDepartmentView, "program_department.json")}
  end

  def render("show.json", %{program_department: program_department}) do
    %{data: render_one(program_department, ProgramDepartmentView, "program_department.json")}
  end

  def render("program_department.json", %{program_department: program_department}) do
    %{
      id: program_department.id,
      program_id: program_department.program_id,
      department_id: program_department.department_id,
      admit: program_department.admit
    }
    |> ProgramView.render_program(%{program: program_department.program})
    |> DepartmentView.render_department(%{department: program_department.department})
  end
end
