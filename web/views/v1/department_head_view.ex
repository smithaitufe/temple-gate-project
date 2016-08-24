defmodule PortalApi.V1.DepartmentHeadView do
  use PortalApi.Web, :view

  def render("index.json", %{department_heads: department_heads}) do
    render_many(department_heads, PortalApi.V1.DepartmentHeadView, "department_head.json")
  end

  def render("show.json", %{department_head: department_head}) do
    render_one(department_head, PortalApi.V1.DepartmentHeadView, "department_head.json")
  end

  def render("department_head.json", %{department_head: department_head}) do
    %{id: department_head.id,
      department_id: department_head.department_id,
      staff_id: department_head.staff_id,
      active: department_head.active,
      appointment_date: department_head.appointment_date,
      effective_date: department_head.effective_date,
      end_date: department_head.end_date}
      |> Map.put(:department, render_one(department_head.department, PortalApi.V1.DepartmentView, "department_lite.json"))
  end
end
