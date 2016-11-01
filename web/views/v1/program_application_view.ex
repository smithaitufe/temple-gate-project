defmodule PortalApi.V1.ProgramApplicationView do
  use PortalApi.Web, :view

  def render("index.json", %{program_applications: program_applications}) do
    render_many(program_applications, PortalApi.V1.ProgramApplicationView, "program_application.json")
  end

  def render("show.json", %{program_application: program_application}) do
    render_one(program_application, PortalApi.V1.ProgramApplicationView, "program_application.json")
  end

  def render("program_application.json", %{program_application: program_application}) do
    %{id: program_application.id,
      applicant_user_id: program_application.applicant_user_id,
      registration_no: program_application.registration_no,
      matriculation_no: program_application.matriculation_no,
      program_id: program_application.program_id,
      department_id: program_application.department_id,
      level_id: program_application.level_id,
      entry_mode_id: program_application.entry_mode_id,
      academic_session_id: program_application.academic_session_id,
      is_admitted: program_application.is_admitted,
      active: program_application.active}
  end
end
