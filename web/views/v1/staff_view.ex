defmodule PortalApi.V1.StaffView do
  use PortalApi.Web, :view
  alias PortalApi.V1.StaffView

  def render("index.json", %{staffs: staffs}) do
    render_many(staffs, StaffView, "staff.json")
  end

  def render("show.json", %{staff: staff}) do
    render_one(staff, StaffView, "staff.json")
  end

  def render("staff.json", %{staff: staff}) do
    %{id: staff.id,
      registration_no: staff.registration_no,
      last_name: staff.last_name,
      middle_name: staff.middle_name,
      first_name: staff.first_name,
      marital_status_id: staff.marital_status_id,
      gender_id: staff.gender_id,
      birth_date: staff.birth_date,
      local_government_area_id: staff.local_government_area_id}
  end
end
