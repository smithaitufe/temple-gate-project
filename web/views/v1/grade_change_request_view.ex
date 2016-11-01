defmodule PortalApi.V1.GradeChangeRequestView do
  use PortalApi.Web, :view

  def render("index.json", %{grade_change_requests: grade_change_requests}) do
    render_many(grade_change_requests, PortalApi.V1.GradeChangeRequestView, "grade_change_request.json")
  end

  def render("show.json", %{grade_change_request: grade_change_request}) do
    render_one(grade_change_request, PortalApi.V1.GradeChangeRequestView, "grade_change_request.json")
  end

  def render("grade_change_request.json", %{grade_change_request: grade_change_request}) do
    %{id: grade_change_request.id,
      course_grading_id: grade_change_request.course_grading_id,
      reason_id: grade_change_request.reason_id,
      previous_score: grade_change_request.previous_score,
      previous_grade_letter: grade_change_request.previous_grade_letter,
      previous_grade_id: grade_change_request.previous_grade_id,
      current_score: grade_change_request.current_score,
      current_grade_letter: grade_change_request.current_grade_letter,
      current_grade_id: grade_change_request.current_grade_id,
      requester_user_id: grade_change_request.requester_user_id,
      read: grade_change_request.read,
      approved: grade_change_request.approved,
      closed: grade_change_request.closed,
      closed_at: grade_change_request.closed_at,
      closed_by_user_id: grade_change_request.closed_by_user_id
    }
    |> Map.put(:reason, render_one(grade_change_request.reason, PortalApi.V1.TermView, "term.json"))
    |> Map.put(:requester, render_one(grade_change_request.requester, PortalApi.V1.UserView, "user.json"))
    |> Map.put(:closed_by, render_one(grade_change_request.closed_by, PortalApi.V1.UserView, "user.json"))
  end
end
