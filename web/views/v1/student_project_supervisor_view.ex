defmodule PortalApi.V1.StudentProjectSupervisorView do
  use PortalApi.Web, :view

  def render("index.json", %{student_project_supervisors: student_project_supervisors}) do
    %{data: render_many(student_project_supervisors, PortalApi.V1.StudentProjectSupervisorView, "student_project_supervisor.json")}
  end

  def render("show.json", %{student_project_supervisor: student_project_supervisor}) do
    %{data: render_one(student_project_supervisor, PortalApi.V1.StudentProjectSupervisorView, "student_project_supervisor.json")}
  end

  def render("student_project_supervisor.json", %{student_project_supervisor: student_project_supervisor}) do
    %{id: student_project_supervisor.id,
      staff_id: student_project_supervisor.staff_id,
      student_id: student_project_supervisor.student_id,
      project_status_id: student_project_supervisor.project_status_id}
  end
end
