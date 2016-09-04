defmodule PortalApi.V1.StaffLeaveRequestView do
  use PortalApi.Web, :view

  def render("index.json", %{staff_leave_requests: staff_leave_requests}) do
    render_many(staff_leave_requests, PortalApi.V1.StaffLeaveRequestView, "staff_leave_request.json")
  end

  def render("show.json", %{staff_leave_request: staff_leave_request}) do
    render_one(staff_leave_request, PortalApi.V1.StaffLeaveRequestView, "staff_leave_request.json")
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
      duration: staff_leave_request.duration,
      closed: staff_leave_request.closed,
      closed_at: staff_leave_request.closed_at,
      signed: staff_leave_request.signed,
      signed_by_staff_id: staff_leave_request.signed_by_staff_id,
      accepted: staff_leave_request.accepted,
      deferred: staff_leave_request.deferred
    }
      |> Map.put(:closed_by, render_one(staff_leave_request.closed_by, PortalApi.V1.StaffView, "staff_lite.json"))
      |> Map.put(:signed_by, render_one(staff_leave_request.signed_by, PortalApi.V1.StaffView, "staff_lite.json"))

  end
end
