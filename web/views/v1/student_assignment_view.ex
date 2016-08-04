defmodule PortalApi.V1.StudentAssignmentView do
  use PortalApi.Web, :view


  def render("index.json", %{student_assignments: student_assignments}) do
    render_many(student_assignments, PortalApi.V1.StudentAssignmentView, "student_assignment.json")
  end

  def render("show.json", %{student_assignment: student_assignment}) do
    render_one(student_assignment, PortalApi.V1.StudentAssignmentView, "student_assignment.json")
  end

  def render("student_assignment.json", %{student_assignment: student_assignment}) do
    %{
      id: student_assignment.id,
      student_id: student_assignment.student_id,
      assignment_id: student_assignment.assignment_id,
      submission: student_assignment.submission
    }
  end
end
