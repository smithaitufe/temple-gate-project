defmodule PortalApi.V1.AssignmentView do
  use PortalApi.Web, :view

  def render("index.json", %{assignments: assignments}) do
    %{data: render_many(assignments, PortalApi.V1.AssignmentView, "assignment.json")}
  end

  def render("show.json", %{assignment: assignment}) do
    %{data: render_one(assignment, PortalApi.V1.AssignmentView, "assignment.json")}
  end

  def render("assignment.json", %{assignment: assignment}) do
    %{id: assignment.id,
      staff_id: assignment.staff_id,
      course_id: assignment.course_id,
      question: assignment.question,
      note: assignment.note,
      closing_date: assignment.closing_date,
      closing_time: assignment.closing_time}
  end
end
