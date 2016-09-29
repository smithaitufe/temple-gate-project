defmodule PortalApi.V1.AssignmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{AssignmentView, CourseView, AcademicSessionView, StaffView}

  def render("index.json", %{assignments: assignments}) do
    render_many(assignments, AssignmentView, "assignment.json")
  end

  def render("show.json", %{assignment: assignment}) do
    render_one(assignment, AssignmentView, "assignment.json")
  end

  @course_fields [:title, :units, :hours]
  def render("assignment.json", %{assignment: assignment}) do
    %{id: assignment.id,
      staff_id: assignment.staff_id,
      course_id: assignment.course_id,
      question: assignment.question,
      note: assignment.note,
      start_date: assignment.start_date,
      start_time: assignment.start_time,
      stop_date: assignment.stop_date,
      stop_time: assignment.stop_time,
      academic_session_id: assignment.academic_session_id
    }
    |> Map.put(:course, render_one(assignment.course, CourseView, "course_lite.json"))
    |> Map.put(:academic_session, render_one(assignment.academic_session, AcademicSessionView, "academic_session.json"))
  end

end
