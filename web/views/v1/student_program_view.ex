defmodule PortalApi.V1.StudentProgramView do
  use PortalApi.Web, :view

  def render("index.json", %{student_programs: student_programs}) do
    render_many(student_programs, PortalApi.V1.StudentProgramView, "student_program.json")
  end

  def render("show.json", %{student_program: student_program}) do
    render_one(student_program, PortalApi.V1.StudentProgramView, "student_program.json")
  end

  def render("student_program.json", %{student_program: student_program}) do
    %{
      id: student_program.id,
      student_id: student_program.student_id,
      program_id: student_program.program_id,
      department_id: student_program.department_id,
      level_id: student_program.level_id,
      academic_session_id: student_program.academic_session_id
    }
  end
end
