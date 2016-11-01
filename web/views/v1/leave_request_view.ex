defmodule PortalApi.V1.LeaveRequestView do
  use PortalApi.Web, :view

  def render("index.json", %{leave_requests: leave_requests}) do
    render_many(leave_requests, PortalApi.V1.LeaveRequestView, "leave_request.json")
  end

  def render("show.json", %{leave_request: leave_request}) do
    render_one(leave_request, PortalApi.V1.LeaveRequestView, "leave_request.json")
  end

  def render("leave_request.json", %{leave_request: leave_request}) do
    %{id: leave_request.id,
      requested_by_user_id: leave_request.requested_by_user_id,
      proposed_start_date: leave_request.proposed_start_date,
      proposed_end_date: leave_request.proposed_end_date,
      read: leave_request.read,
      closed_by_user_id: leave_request.closed_by_user_id,
      details: leave_request.details,
      approved: leave_request.approved,
      approved_start_date: leave_request.approved_start_date,
      approved_end_date: leave_request.approved_end_date,
      duration: leave_request.duration,
      closed: leave_request.closed,
      closed_at: leave_request.closed_at,
      signed: leave_request.signed,
      signed_by_user_id: leave_request.signed_by_user_id,
      accepted: leave_request.accepted,
      deferred: leave_request.deferred
    }
      |> Map.put(:requested_by, render_one(leave_request.requested_by, PortalApi.V1.UserView, "user.json"))      
      |> Map.put(:signed_by, render_one(leave_request.signed_by, PortalApi.V1.UserView, "user.json"))
      |> Map.put(:closed_by, render_one(leave_request.closed_by, PortalApi.V1.UserView, "user.json"))
      

  end
end
