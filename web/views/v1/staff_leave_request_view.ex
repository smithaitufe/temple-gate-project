defmodule PortalApi.V1.StaffLeaveRequestView do
  use PortalApi.Web, :view

  def render("index.json", %{staff_leave_requests: staff_leave_requests}) do
    %{data: render_many(staff_leave_requests, PortalApi.V1.StaffLeaveRequestView, "staff_leave_request.json")}
  end

  def render("show.json", %{staff_leave_request: staff_leave_request}) do
    %{data: render_one(staff_leave_request, PortalApi.V1.StaffLeaveRequestView, "staff_leave_request.json")}
  end

  def render("staff_leave_request.json", %{staff_leave_request: staff_leave_request}) do
    %{id: staff_leave_request.id,
      staff_id: staff_leave_request.staff_id,
      proposed_start_date: staff_leave_request.proposed_start_date,
      proposed_end_date: staff_leave_request.proposed_end_date,
      read: staff_leave_request.read,
      closed_by_staff_id: staff_leave_request.closed_by_staff_id,
      details: staff_leave_request.details,
      approved: staff_leave_request.approved,
      approved_start_date: staff_leave_request.approved_start_date,
      approved_end_date: staff_leave_request.approved_end_date,
      no_of_days: staff_leave_request.no_of_days,
      closed: staff_leave_request.closed,
      closed_at: staff_leave_request.closed_at}
  end
end
