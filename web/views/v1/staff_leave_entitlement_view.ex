defmodule PortalApi.V1.StaffLeaveEntitlementView do
  use PortalApi.Web, :view

  def render("index.json", %{staff_leave_entitlements: staff_leave_entitlements}) do
    %{data: render_many(staff_leave_entitlements, PortalApi.V1.StaffLeaveEntitlementView, "staff_leave_entitlement.json")}
  end

  def render("show.json", %{staff_leave_entitlement: staff_leave_entitlement}) do
    %{data: render_one(staff_leave_entitlement, PortalApi.V1.StaffLeaveEntitlementView, "staff_leave_entitlement.json")}
  end

  def render("staff_leave_entitlement.json", %{staff_leave_entitlement: staff_leave_entitlement}) do
    %{id: staff_leave_entitlement.id,
      staff_id: staff_leave_entitlement.staff_id,
      leave_track_type_id: staff_leave_entitlement.leave_track_type_id,
      entitled_leave: staff_leave_entitlement.entitled_leave,
      remaining_leave: staff_leave_entitlement.remaining_leave}
  end
end
