defmodule PortalApi.V1.StudentCertificateItemView do
  use PortalApi.Web, :view

  def render("index.json", %{student_certificate_items: student_certificate_items}) do
    render_many(student_certificate_items, PortalApi.V1.StudentCertificateItemView, "student_certificate_item.json")
  end

  def render("show.json", %{student_certificate_item: student_certificate_item}) do
    render_one(student_certificate_item, PortalApi.V1.StudentCertificateItemView, "student_certificate_item.json")
  end

  def render("student_certificate_item.json", %{student_certificate_item: student_certificate_item}) do
    %{id: student_certificate_item.id,
      student_certificate_id: student_certificate_item.student_certificate_id,
      subject_id: student_certificate_item.subject_id,
      grade_id: student_certificate_item.grade_id}
  end
end
