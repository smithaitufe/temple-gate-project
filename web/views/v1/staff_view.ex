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
    render("staff_lite.json", staff: staff)
    |> Map.put(:marital_status, render_one(staff.marital_status, PortalApi.V1.TermView, "term.json"))
    |> Map.put(:gender, render_one(staff.gender, PortalApi.V1.TermView, "term.json"))
    |> Map.put(:local_government_area, render_one(staff.local_government_area, PortalApi.V1.LocalGovernmentAreaView, "local_government_area.json"))

  end

  def render("staff_lite.json", %{staff: staff}) do
    %{
      id: staff.id,
      registration_no: staff.registration_no,
      last_name: staff.last_name,
      middle_name: staff.middle_name,
      first_name: staff.first_name,
      marital_status_id: staff.marital_status_id,
      gender_id: staff.gender_id,
      birth_date: staff.birth_date,
      local_government_area_id: staff.local_government_area_id
    }
  end

end
