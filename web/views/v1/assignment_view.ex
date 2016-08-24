defmodule PortalApi.V1.AssignmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.AssignmentView

  def render("index.json", %{assignments: assignments}) do
    render_many(assignments, AssignmentView, "assignment.json")
  end

  def render("show.json", %{assignment: assignment}) do
    render_one(assignment, AssignmentView, "assignment.json")
  end

  def render("assignment.json", %{assignment: assignment}) do
    %{id: assignment.id,
      staff_id: assignment.staff_id,
      course_id: assignment.course_id,
      question: assignment.question,
      note: assignment.note,
      closing_date: assignment.closing_date,
      closing_time: assignment.closing_time,
      academic_session_id: assignment.academic_session_id
    }
  end
end
