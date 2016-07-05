defmodule PortalApi.V1.StudentView do
  use PortalApi.Web, :view

  def render("index.json", %{students: students}) do
    %{data: render_many(students, PortalApi.V1.StudentView, "student.json")}
  end

  def render("show.json", %{student: student}) do
    %{data: render_one(student, PortalApi.V1.StudentView, "student.json")}
  end

  def render("student.json", %{student: student}) do
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
      level_id: student.level_id}
  end
end
