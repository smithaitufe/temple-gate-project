defmodule PortalApi.V1.StudentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{StudentView, ProgramView, LevelView, DepartmentView, TermView}

  def render("index.json", %{students: students}) do
    render_many(students, StudentView, "student.json")
  end

  def render("show.json", %{student: student}) do
    render_one(student, StudentView, "student.json")
  end

  def render("student.json", %{student: student}) do
      render("student_lite.json", student: student)
      |> ProgramView.render_program(%{program: student.program})
      |> LevelView.render_level(%{level: student.level})
      |> DepartmentView.render_department(%{department: student.department})
      |> TermView.render_term("marital_status", %{term: student.marital_status})
      |> TermView.render_term("gender", %{term: student.gender})

  end

  def render("student_lite.json", %{student: student}) do
    %{id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      middle_name: student.middle_name,
      birth_date: student.birth_date,
      gender_id: student.gender_id,
      marital_status_id: student.marital_status_id,
      phone_number: student.phone_number,
      email: student.email,
      registration_no: student.registration_no,
      matriculation_no: student.matriculation_no,
      academic_session_id: student.academic_session_id,
      department_id: student.department_id,
      program_id: student.program_id,
      level_id: student.level_id,
      entry_mode_id: student.entry_mode_id,
      user_id: student.user_id
    }
  end



  def render_student(json, %{student: student}) when is_map(student) do
    Map.put(json, :student, render_one(student, PortalApi.V1.StudentView, "student.json"))
  end
  def render_student(json, _) do
    json
  end

end
